RSpec.shared_context 'with test indices' do
  let(:test_elastic_url) { ENV['ELASTICSEARCH_URL'] }
  let(:test_index) { 'elastic_index' }
  let(:test_type) { 'test_model' }
  let(:test_document_id) { '1' }
  let(:test_client) { ::Elasticsearch::Client.new(url: test_elastic_url) }

  let(:test_model) do
    class TestModel < ElasticsearchOrm::Model; end
    TestModel.config(
      url: test_elastic_url,
      index: test_index,
      index_settings: index_settings_for_one_shard
    )
    TestModel
  end

  let(:test_multitype_model) do
    class TestModel < ElasticsearchOrm::Model; multitype; end
    TestModel.config(
      url: test_elastic_url,
      index: test_index,
      index_settings: index_settings_for_one_shard
    )
    TestModel
  end

  after do
    undef_model :TestModel
  end

  def undef_model(name)
    Object.send(:remove_const, name) if Object.constants.include?(name)
  end

  def index_exists?(index_name)
    test_client.indices.exists?(index: index_name)
  end

  def create_test_index
    one_shard_only = { body: { settings: index_settings_for_one_shard } }
    test_client.indices.create(one_shard_only.merge(index: test_index)) unless index_exists?(test_index)
  end

  def create_index(index_name)
    test_client.indices.create(index: index_name)
  end

  def drop_test_index
    drop_index(test_index)
  end

  def drop_index(index_name)
    test_client.indices.delete(index: index_name) if index_exists?(index_name)
  end

  def create_alias(alias_name, index_name)
    test_client.indices.put_alias(name: alias_name, index: index_name)
  end

  def drop_alias(alias_name, index_name)
    test_client.indices.delete_alias(name: alias_name, index: index_name) if alias_exists?(alias_name, index_name)
  end

  def alias_exists?(alias_name, index_name)
    test_client.indices.exists_alias(name: alias_name, index: test_index)
  end

  def purge_test_index
    drop_test_index
    create_test_index
  end

  def index_test_document(overrides = {})
    default_args = { index: test_index, type: test_type, id: test_document_id, body: { name: 'test' } }
    test_client.index(default_args.merge(overrides))
  end

  def count_test_documents
    test_client.count(index: test_index)['count']
  end

  def test_elastic_flush
    test_client.indices.flush
    test_client.cluster.health(wait_for_status: 'yellow')
  end

  def test_mapping
    test_client.indices.get_mapping(index: test_index, type: test_type)[test_index]['mappings'][test_type]
  end

  def config_test_model_class(model_class)
    model_class.config(
      url: test_elastic_url,
      index: test_index,
      index_settings: index_settings_for_one_shard
    )
    model_class
  end
end
