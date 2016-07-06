require_relative '../../services/match_finder_service'

RSpec.describe MatchFinderService do
  let(:service) { described_class.new(sql) }
  let(:sql) { 'select field_name from table skip 1 limit 2' }

  describe '#field_names' do
    it { expect(service.field_names).to eq('field_name: 1') }
  end

  describe '#table_name' do
    it { expect(service.table_name).to eq('table') }
  end

  describe '#condition_string' do
    pending
  end

  describe '#skip_number' do
    it { expect(service.skip_number).to eq('1') }
  end

  describe '#limit_number' do
    it { expect(service.limit_number).to eq('2') }
  end
end
