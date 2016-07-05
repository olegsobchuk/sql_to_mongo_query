Dir["#{File.dirname(__FILE__)}/services/*.rb"].each { |file| require_relative file }
require 'mongo'

puts 'Please enter your DB name'
db_name = gets.chomp

puts "You filled in #{db_name}!"

client = Mongo::Client.new(['127.0.0.1:27017'], database: db_name)
puts 'Connected'
puts 'Please enter your SQL query'
query = gets.chomp

res = Generator.new(client, query).builder

res.each do |u|
  puts u
end

exit
