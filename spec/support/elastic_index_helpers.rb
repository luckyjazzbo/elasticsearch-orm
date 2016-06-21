module ElasticIndexHelpers
  def index_settings_for_one_shard
    { number_of_shards: 1, number_of_replicas: 0 }
  end

  def flush_and_wait_for_green_status(client)
    client.indices.flush
    client.cluster.health(wait_for_status: 'green')
  end
end

RSpec.configure do |config|
  config.include ElasticIndexHelpers
end
