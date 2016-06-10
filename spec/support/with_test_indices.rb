RSpec.shared_context 'with test indices' do
  let(:test_elastic_url) { ENV['EVA_ELASTICSEARCH_URL'] }
  let(:test_index) { 'elastic_index' }
  let(:test_type) { 'elastic_type' }
  let(:test_client) { ::Elasticsearch::Client.new(url: test_elastic_url) }

  def test_index_exists?
    test_client.indices.exists?(index: test_index)
  end

  def create_test_index
    one_shard_only = { body: { settings: { number_of_shards: 1, number_of_replicas: 0 } } }
    test_client.indices.create(one_shard_only.merge(index: test_index)) unless test_index_exists?
  end

  def drop_test_index
    test_client.indices.delete(index: test_index) if test_index_exists?
  end

  def purge_test_index
    drop_test_index
    create_test_index
  end

  def index_test_document
    test_client.index(index: test_index, type: test_type, id: '1', body: { name: 'test' })
  end

  def count_test_documents
    test_client.count(index: test_index)['count']
  end

  def test_elastic_flush
    test_client.indices.flush
    test_client.cluster.health(wait_for_status: 'green')
  end
end
