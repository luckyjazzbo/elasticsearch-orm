RSpec.shared_context 'with eva indices' do
  let(:eva_resource) { ::Mes::Elastic::Resource }

  before(:each) do
    eva_resource.config(index_settings: index_settings_for_one_shard)
    eva_resource.purge_index!
    flush_and_wait_for_green_status(eva_resource.client)
  end
end
