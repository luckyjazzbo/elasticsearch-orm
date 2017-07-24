require 'spec_helper'

RSpec.describe Mes::Video do
  before(:all) do
    wait_for_being_available(described_class.client)
    described_class.purge_index!
    described_class.create_mapping
  end

  before(:each) do
    described_class.delete_all
    flush_elastic_indices(described_class.client)
  end

  it 'stores videos' do
    expect { FactoryGirl.create(:video) }
      .to change { described_class.all.total_count }
      .from(0).to(1)
  end

  context 'searching for können' do
    let!(:video) { FactoryGirl.create(:video, titles: { de: 'können' }) }
    it 'returns the video' do
      expect(described_class.match('titles.de.basic', 'können').total_count).to eq(1)
    end
  end

  context 'searching for substring' do
    let!(:videos) do
      [
        FactoryGirl.create(:video, titles: { en: 'test' }),
        FactoryGirl.create(:video, titles: { en: 'bla' }),
      ]
    end
    it 'returns the video' do
      expect(described_class.match('titles.en.relaxed', 'tst').total_count).to eq(1)
    end
  end
end
