require_relative '../lib/client_search'

RSpec.describe DataScout::ClientSearch do
  let(:sample_clients) do
    [
      { "id" => 1, "full_name" => "John Doe", "email" => "john@example.com" },
      { "id" => 2, "full_name" => "Jane Smith", "email" => "jane@example.com" },
      { "id" => 3, "full_name" => "Alex Johnson", "email" => "john@example.com" }
    ]
  end

  before do
    allow(DataScout::DataLoader).to receive(:load_clients).and_return(sample_clients)
  end

  subject(:search) { described_class.new }

  describe '#find' do
    it 'finds by default key full_name' do
      expect { search.find("john") }.to output(/John Doe/).to_stdout
    end

    it 'finds by default key full_name' do
      expect { search.find("JohN") }.to output(/John Doe/).to_stdout
    end

    it 'does not find any clients by default key full_name' do
      expect { search.find("XYZ") }.to output(/No clients found for full_name: 'XYZ'/).to_stdout
    end

    it 'finds by email' do
      expect { search.find("jane", "email") }.to output(/Jane Smith/).to_stdout
    end

    it 'does not find email' do
      expect { search.find("XYZ", "email") }.to output(/No clients found for email: 'XYZ'/).to_stdout
    end

    it 'shows error on invalid search key' do
      expect { search.find("john", "nickname") }.to output(/No clients found for nickname: 'john'/).to_stdout
    end
  end

  describe '#method_missing' do
    it 'calls dynamic find_by_full_name' do
      expect { search.find_by_full_name("alex") }.to output(/Alex Johnson/).to_stdout
    end

    it 'calls dynamic find_by_email with duplicates' do
      expect { search.find_by_email("john@example.com") }.to output(/John Doe.*Alex Johnson/m).to_stdout
    end

    it 'handles unknown method gracefully' do
      expect { search.nonexistent_method }.to raise_error(NoMethodError)
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true for dynamic methods' do
      expect(search.respond_to?(:find_by_email)).to be true
      expect(search.respond_to?(:find_by_full_name)).to be true
    end

    it 'returns false for unrelated methods' do
      expect(search.respond_to?(:foobar)).to be false
    end
  end

  describe '#find_duplicates' do
    it 'outputs duplicate email information' do
      expect { search.find_duplicates }.to output(/john@example.com appears 2 times/).to_stdout
    end

    it 'says no duplicates if none found' do
      allow(DataScout::DataLoader).to receive(:load_clients).and_return([
        { "id" => 1, "full_name" => "Alice", "email" => "alice@example.com" },
        { "id" => 2, "full_name" => "Bob", "email" => "bob@example.com" }
      ])
      expect { described_class.new.find_duplicates }.to output(/No duplicate emails found/).to_stdout
    end
  end
end
