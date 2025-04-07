require 'json'
require 'net/http'
require 'uri'

module DataScout
  class DataLoader
    def initialize(api_endpoint = nil)
      @api_endpoint = api_endpoint || 'https://appassets02.shiftcare.com/manual/clients.json'
      @clients = nil
    end

    def self.load_clients(api_endpoint = nil)
      new(api_endpoint).load_clients
    end

    def load_clients
      return @clients if @clients

      uri = URI.parse(@api_endpoint)

      begin
        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          @clients = JSON.parse(response.body)
        else
          raise "Failed to fetch clients: HTTP #{response.code} - #{response.message}"
        end
      rescue JSON::ParserError => e
        raise "Invalid JSON received from #{@api_endpoint}: #{e.message}"
      rescue => e
        raise "Error loading clients: #{e.message}"
      end

      @clients
    end
  end
end
