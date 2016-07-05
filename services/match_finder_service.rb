class MatchFinderService
  def initialize(query)
    @query = query
  end

  def field_names
    fields = match_finder('select')
    fields.gsub(/(\w+\.)?\*,\s+/, '') if fields
  end

  def table_name
    @table ||= match_finder('from')
  end

  def condition_string
    @condition ||= match_finder('where')
  end

  def skip_number
    @skip ||= match_finder('skip')
  end

  def limit_number
    @limit ||= match_finder('limit')
  end

  private

  def match_finder(selector)
    expression = /(?<=#{selector} )(.*?)(?= select|from|where|skip|limit|$)/i
    result = @query.match(expression)
    result[1].strip if result
  end
end
