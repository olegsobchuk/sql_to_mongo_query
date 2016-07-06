require 'pry'

class MatchFinderService
  CONDITIONS = {
    '=' => ' $eq ', '<>' => ' $ne ', '>' => ' $gt ', '>=' => ' $gte ', '<' => ' $lt ', '<=' => ' $lte '
  }.freeze
  ORDER_KEYWORDS = { 'ASC' => 1, 'DESC' => -1 }

  def initialize(query)
    @query = query
  end

  def field_names
    fields = match_finder('select')
    fields.gsub(/(\w+\.?\w+)/, '\'\1\' => 1') if fields
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
    @order ||= match_finder('order by')
    orders = @order.split(/,\s+/)if @order
    orders_to_mongo(orders)
    orders_to_string(orders)
  end

  private

  def match_finder(selector)
    expression = /(?<=#{selector} )(.*?)(?= select|from|where|skip|limit|order by|$)/i
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
    "{ '$and' => [#{data.map { |s| "{ '$or' => [#{s.empty? ? '{}' : s.join(', ')}]}" }.join(', ')}] }"
  end

  def orders_to_mongo(sql_orders)
    sql_orders.map! do |ord|
      ord.gsub(/\s*(\w+)\s+(asc|desc)/i) {
        "'#{Regexp.last_match[1]}' => #{ORDER_KEYWORDS[Regexp.last_match[2]]}"
      }
    end
  end

  def orders_to_string(array_orders)
    array_orders.join(', ')
  end
end
