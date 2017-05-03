require 'factory_girl'

RSpec.shared_context 'with eva indices' do
  let(:eva_resource) { ::Eva::Elastic::Resource }

  before(:all) do
    Dir[File.join(Mes::Elastic::ROOT, 'spec/factories/eva/*.rb')].each { |file| require(file) }
    wait_for_being_available(::Eva::Elastic::Resource.client)
  end

  before(:each) do
    eva_resource.config(index_settings: index_settings_for_one_shard)
    unless eva_resource.index_exists?
      eva_resource.create_index
      ::Eva::Elastic.models.each(&:create_mapping)
    end
    eva_resource.delete_all
    flush_eva_indices
  end

  def flush_eva_indices
    flush_elastic_indices(eva_resource.client)
  end
end
