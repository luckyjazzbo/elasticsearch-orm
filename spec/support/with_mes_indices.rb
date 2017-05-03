require 'factory_girl'

RSpec.shared_context 'with mes indices' do
  let(:mes_resource) { ::Mes::Elastic::Resource }

  before(:all) do
    Dir[File.join(Mes::Elastic::ROOT, 'spec/factories/mes/*.rb')].each { |file| require(file) }
    wait_for_being_available(mes_resource.client)
  end

  before(:each) do
    mes_resource.config(index_settings: index_settings_for_one_shard)
    unless mes_resource.index_exists?
      mes_resource.create_index
      ::Mes::Elastic.models.each(&:create_mapping)
    end
    mes_resource.delete_all
    flush_mes_indices
  end

  def flush_mes_indices
    flush_elastic_indices(mes_resource.client)
  end
end
