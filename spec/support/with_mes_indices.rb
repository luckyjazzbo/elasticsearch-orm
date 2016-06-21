RSpec.shared_context 'with mes indices' do
  let(:mes_resource) { ::Mes::Elastic::Resource }

  before(:each) do
    mes_resource.config(index_settings: index_settings_for_one_shard)
    mes_resource.purge_index!
    flush_and_wait_for_green_status(mes_resource.client)
  end
end
