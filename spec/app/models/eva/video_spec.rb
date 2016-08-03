require 'spec_helper'

RSpec.describe Eva::Elastic::Video do
  include_context 'with eva indices'

  describe '.create_mapping' do
    before do
      described_class.drop_index!
      described_class.create_index
      flush_eva_indices
    end

    it 'creates mapping' do
      expect {
        described_class.create_mapping
      }.not_to raise_error
    end
  end
end
