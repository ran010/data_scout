#!/usr/bin/env ruby

require_relative '../lib/client_search'
require 'pry'
puts "Welcome to DataScout."
puts "Available commands:"
puts "  search <query> [search_key] - Find clients by name (default key: full_name)"
puts "  duplicates                  - Check for duplicate emails"
puts "  exit                        - Quit the CLI"
client_search = DataScout::ClientSearch.new

loop do
  print "\n> "
  input = gets.chomp.strip
  break if input.downcase == "exit" || input.downcase == "quit"

  args = input.split(" ")
  command = args[0]
  query = args[1]
  search_key = args[2] || 'full_name'

  case command
  when "search"
    if query.nil?
      puts "Usage: search <query> [search_key]"
    else
      client_search.find(query, search_key)
    end
  when "duplicates"
    client_search.find_duplicates
  else
    puts "Invalid command. Try:"
    puts "  search <query> [search_key]"
    puts "  duplicates"
    puts "  exit"
  end
end

puts "Thank you!"
