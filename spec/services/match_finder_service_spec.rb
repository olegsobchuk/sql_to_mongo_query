require_relative '../../services/match_finder_service'

RSpec.describe MatchFinderService do
  describe '#field_names' do
    let(:service) { described_class.new(sql) }
    let(:sql) { 'select field_name from table' }

    it { expect(service.field_names).to eq('field_name') }
  end
end
