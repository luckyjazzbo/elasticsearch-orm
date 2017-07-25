require 'spec_helper'

RSpec.describe Mes::Taxonomy do
  before(:all) do
    wait_for_being_available(described_class.client)
    described_class.purge_index!
    described_class.create_mapping
  end

  before(:each) do
    described_class.delete_all
    flush_elastic_indices(described_class.client)
  end

  it 'stores taxonomies' do
    expect { FactoryGirl.create(:taxonomy) }
      .to change { described_class.all.total_count }
      .from(0).to(1)
  end
end
