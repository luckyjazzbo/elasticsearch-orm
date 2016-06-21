RSpec.shared_context 'with eva indices' do
  let(:eva_resource) { ::Mes::Elastic::Resource }

  before(:each) do
    eva_resource.config(index_settings: index_settings_for_one_shard)
    eva_resource.delete_all
    flush_eva_indices
  end

  def flush_eva_indices
    flush_elastic_indices(eva_resource.client)
  end
end
