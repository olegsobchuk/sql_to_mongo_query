require_relative '../../services/generator'

RSpec.describe Generator do
  before { allow(MatchFinderService).to receive(:new) { match_finder_service } }

  let(:match_finder_service) do
    double :match_finder_service,
      table_name: table_name,
      limit_number: limit_number,
      skip_number: skip_number
  end
  let(:table_name) { 'table' }
  let(:limit_number) { 1 }
  let(:skip_number) { 2 }
  let(:client) { double(:client) }
  let(:service) { described_class.new(client, sql) }
  let(:sql) do
    %Q{ select field_name from #{table_name} skip #{skip_number} limit #{limit_number} }
  end

  describe '#builder' do
    before { allow(client).to receive_message_chain(:[], :find, :limit, :skip) }
    after { service.builder }

    it { expect(client).to receive_message_chain(:[], :find, :limit, :skip) }
  end
end
