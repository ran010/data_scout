require_relative 'data_loader'

module DataScout
  class ClientSearch

    def initialize(file_path = nil)
      @clients = DataScout::DataLoader.load_clients(file_path)
    end

    def find(query, key = 'full_name')
      method_name = "find_by_#{key}"
      if respond_to?(method_name)
        send(method_name, query)
      else
        puts "Invalid search key: #{key}"
      end
    end

    def find_duplicates
      email_count = Hash.new(0)

      @clients.each do |client|
        email_count[client["email"]] += 1
      end

      duplicates = email_count.select { |_, count| count > 1 }
      if duplicates.empty?
        puts "No duplicate emails found."
      else
        puts "Duplicate emails found:"
        duplicates.each { |email, count| puts "#{email} appears #{count} times" }
      end
    end

    private

    def method_missing(method_name, *args, &block)
      method_str = method_name.to_s

      # Match method like `find_by_<attribute>`
      if method_str.start_with?('find_by_')
        search_key = method_str.sub('find_by_', '')
        query = args.first

        return dynamic_find(query, search_key)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.start_with?('find_by_') || super
    end

    def dynamic_find(query, search_key)
      results = []

      @clients.each do |client|
        value = client[search_key]
        next unless value.is_a?(String) || value.is_a?(Numeric)

        if value.to_s.downcase.include?(query.downcase)
          results << client
        end
      end

      if results.empty?
        puts "No clients found for #{search_key}: '#{query}'"
      else
        results.each do |client|
          client.each do |key, value|
            print "#{key}: #{value} "
          end
          puts
        end
      end
    end
  end
end
