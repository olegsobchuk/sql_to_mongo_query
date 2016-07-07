require_relative '../../services/sql_parser'

RSpec.describe SqlParser do
  let(:service) { described_class.new(sql) }
  let(:sql) { 'select field_name from table where age > 18 skip 1 limit 2 order by age asc' }
  let(:expected_condition) { "{ '$and' => [{ '$or' => ['age' => { '$gt' => 18 }]}] }" }

  describe '#field_names' do
    it { expect(service.field_names).to eq("'field_name' => 1") }
  end

  describe '#table_name' do
    it { expect(service.table_name).to eq('table') }
  end

  describe '#condition_string' do
    context 'when condition present' do
      it { expect(service.condition_string).to eq(expected_condition) }
    end

    context 'when condition absent' do
      let(:sql) { 'select field_name from table' }

      it { expect(service.condition_string).to eq('{}') }
    end
  end

  describe '#skip_number' do
    it { expect(service.skip_number).to eq('1') }
  end

  describe '#limit_number' do
    it { expect(service.limit_number).to eq('2') }
  end

  describe '#sorted' do
    it { expect(service.sorted).to eq("'age' => 1") }
  end
end
