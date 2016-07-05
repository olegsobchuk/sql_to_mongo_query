require 'pry'
require_relative 'match_finder_service'

class Generator
  attr_reader :client, :sql, :finders

  def initialize(mongo_client, sql)
    @client = mongo_client
    @sql = sql
    @finders = MatchFinderService.new(sql)
  end

  def builder
    request = "client['#{finders.table_name}'].find"
    request += ".limit(#{finders.limit_number})" if finders.limit_number
    request += ".skip(#{finders.skip_number})" if finders.skip_number
    eval(request)
  end
end