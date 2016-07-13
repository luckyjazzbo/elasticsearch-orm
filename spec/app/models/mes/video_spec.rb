require 'spec_helper'

RSpec.describe Mes::Elastic::Video do
  include_context 'with mes indices'

  describe '.create_mapping' do
    before do
      described_class.drop_index!
      described_class.create_index
      flush_mes_indices
    end

    it 'creates mapping' do
      expect {
        described_class.create_mapping
      }.not_to raise_error Elasticsearch::Transport::Transport::Errors::BadRequest
    end
  end
end
