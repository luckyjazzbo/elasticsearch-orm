module ElasticIndexHelpers
  def index_settings_for_one_shard
    { number_of_shards: 1, number_of_replicas: 0 }
  end

  def flush_elastic_indices(client)
    client.indices.flush
    client.cluster.health(wait_for_status: 'green')
  end

  def recursive_stringify_mapping(mapping)
    str_mapping = mapping.deep_stringify_keys
    str_mapping.each do |key, value|
      case value
      when Symbol
        str_mapping[key] = value.to_s
      when Hash
        str_mapping[key] = recursive_stringify_mapping(value)
      end
    end
    str_mapping
  end
end

RSpec.configure do |config|
  config.include ElasticIndexHelpers
end
