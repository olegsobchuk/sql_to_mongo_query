# Dir["#{File.dirname(__FILE__)}/services/*.rb"].each { |file| require_relative file }
require_relative 'services/generator'
require 'mongo'

puts 'Please enter your DB name'
db_name = gets.chomp

puts "You filled in #{db_name}!"

client = Mongo::Client.new(['127.0.0.1:27017'], database: db_name)
puts 'Connected'
puts 'Please enter your SQL query'
query = gets.chomp

response = Generator.new(client, query).builder

puts 'RESULT'

response.each do |obj|
  puts obj
end
