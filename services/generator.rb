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
    request = "client['#{finders.table_name}'].find({#{finders.condition_string}}, {#{finders.field_names}})"
    request += ".limit(#{finders.limit_number})" if finders.limit_number
    request += ".skip(#{finders.skip_number})" if finders.skip_number
    request += ".sort(#{finders.sorted})" if finders.sorted
    eval(request)
  end
end
