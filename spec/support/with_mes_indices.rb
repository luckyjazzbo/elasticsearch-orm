require 'factory_girl'

RSpec.shared_context 'with mes indices' do
  let(:mes_resource) { ::Mes::Elastic::Resource }

  before(:all) do
    FactoryGirl.definition_file_paths = [File.join(Mes::Elastic::ROOT, 'spec/factories/mes')]
    FactoryGirl.find_definitions
  end

  before(:each) do
    mes_resource.config(index_settings: index_settings_for_one_shard)
    mes_resource.create_index unless mes_resource.index_exists?
    mes_resource.delete_all
    flush_mes_indices
  end

  def flush_mes_indices
    flush_elastic_indices(mes_resource.client)
  end
end
