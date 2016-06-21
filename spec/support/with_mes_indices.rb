RSpec.shared_context 'with mes indices' do
  let(:mes_resource) { ::Mes::Elastic::Resource }

  before(:each) do
    mes_resource.config(index_settings: index_settings_for_one_shard)
    mes_resource.purge_index!
    flush_mes_indices
  end

  def flush_mes_indices
    flush_elastic_indices(mes_resource.client)
  end
end
