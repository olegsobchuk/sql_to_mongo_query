require_relative '../../services/generator'

RSpec.describe Generator do
  before { allow(SqlParser).to receive(:new) { match_finder_service } }

  let(:match_finder_service) do
    double :match_finder_service,
      table_name: table_name,
      limit_number: limit_number,
      skip_number: skip_number,
      condition_string: "'conditions' => 'value'",
      field_names: "'fields' => 'value'",
      sorted: sort_fields,
      projection: "'age' => 1"
  end
  let(:table_name) { 'table' }
  let(:limit_number) { 1 }
  let(:skip_number) { 2 }
  let(:sort_fields) { "'age' => 1" }
  let(:client) { double(:client) }
  let(:service) { described_class.new(client, sql) }
  let(:sql) do
    %Q{ select age from #{table_name} skip #{skip_number} limit #{limit_number} order by age asc }
  end

  describe '#builder' do
    before { allow(client).to receive_message_chain(:[], :find, :limit, :skip, :sort, :projection) }
    after { service.builder }

    it { expect(client).to receive_message_chain(:[], :find, :limit, :skip, :sort, :projection) }
  end
end
