require 'factory_girl'

RSpec.shared_context 'with content api indices' do
  let(:content_api_resource) { ::ContentApi::Elastic::Resource }

  before(:all) do
    Dir[File.join(Mes::Elastic::ROOT, 'spec/factories/content_api/*.rb')].each { |file| require(file) }
    wait_for_being_available(content_api_resource.client)
  end

  before(:each) do
    content_api_resource.config(index_settings: index_settings_for_one_shard)
    unless content_api_resource.index_exists?
      content_api_resource.create_index
      ::Mes::Elastic.models.each(&:create_mapping)
    end
    content_api_resource.delete_all
    flush_content_api_indices
  end

  def flush_content_api_indices
    flush_elastic_indices(content_api_resource.client)
  end
end
