require_relative '../lib/data_loader'
require 'webmock/rspec'
require 'dotenv/load'

RSpec.describe DataScout::DataLoader do
  let(:api_url) { ENV['DATA_API_ENDPOINT'] }
  let(:client_data) do
    [
      { "id" => 1, "full_name" => "John Doe", "email" => "john@example.com" },
      { "id" => 2, "full_name" => "Jane Smith", "email" => "jane@example.com" }
    ]
  end

  before do
    stub_request(:get, api_url)
      .to_return(status: 200, body: client_data.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  describe '.load_clients' do
    it 'fetches and parses client data from the default API' do
      clients = described_class.load_clients
      expect(clients).to be_an(Array)
      expect(clients.size).to eq(2)
      expect(clients.first["full_name"]).to eq("John Doe")
    end

    it 'memoizes the client data to avoid multiple HTTP requests' do
      expect(Net::HTTP).to receive(:get_response).once.and_call_original
      loader = described_class.new(api_url)
      loader.load_clients
      loader.load_clients # second call should not trigger new HTTP request
    end
  end

  context 'when the API returns invalid JSON' do
    before do
      stub_request(:get, api_url).to_return(status: 200, body: 'not-json')
    end

    it 'raises a JSON::ParserError' do
      expect {
        described_class.load_clients(api_url)
      }.to raise_error(/Invalid JSON/)
    end
  end

  context 'when the API returns an error status' do
    before do
      stub_request(:get, api_url).to_return(status: 500, body: 'Internal Server Error')
    end

    it 'raises an error with HTTP status code' do
      expect {
        described_class.load_clients(api_url)
      }.to raise_error(/Failed to fetch clients/)
    end
  end
end
