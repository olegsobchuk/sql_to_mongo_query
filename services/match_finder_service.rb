require 'pry'

class MatchFinderService
  CONDITIONS = {
    '=' => ' $eq ', '<>' => ' some ', '>' => ' $gt ', '>=' => ' $gte ', '<' => ' $lt ', '<=' => ' $lte '
  }.freeze

  def initialize(query)
    @query = query
  end

  def field_names
    fields = match_finder('select')
    fields.gsub(/(\w+\.?\w+)/, '\1: 1') if fields
  end

  def table_name
    @table ||= match_finder('from')
  end

  def condition_string
    @condition = match_finder('where')
    if @condition
      @condition = @condition.split(/ *OR */i).map { |s| s.split(/ *AND */i)}
      @condition = change_comparison_operands(@condition)
      build_mongo_finder(@condition)
    else
      '{}'
    end
  end

  def skip_number
    @skip ||= match_finder('skip')
  end

  def limit_number
    @limit ||= match_finder('limit')
  end

  def sorted
    false
  end

  private

  def match_finder(selector)
    expression = /(?<=#{selector} )(.*?)(?= select|from|where|skip|limit|$)/i
    result = @query.match(expression)
    result[1].strip if result && !result[1].include?('*')
  end

  def change_comparison_operands(condition_array)
    condition_array.map do |value|
      if value.is_a?(Array)
        change_comparison_operands(value)
      else
        rez = value.gsub(/([>|<|<=|\>\=|=]{1,2})/, CONDITIONS).split(%r{\s+})
        "'#{rez[0]}' => { '#{rez[1]}' => #{rez[2]} }"
      end
    end
  end

  def build_mongo_finder(data)
    "'$and' => [#{data.map { |s| "{ '$or' => [#{s.empty? ? '{}' : s.join(', ')}]}" }.join(', ')}]"
  end
end

# arr = "age < 50 AND name='alex' OR age > 10 or name = 'Oleg'".split(/ *OR */i).map { |s| s.split(/ *AND */i)}
# str = "{ $and: [#{ arr.map { |s| "{ $or : [#{s.empty? ? "{}" : s.join(", ")}]}"}.join(", ")}]"