module ElasticIndexHelpers
  CHECK_AVAILABILITY_INDEX = 'check_availability_index'.freeze

  extend self

  def prepare_elastics
    return @elastics_ready if defined?(@elastics_ready)

    # Anonymous classes for each elastic
    models = ENV.keys.grep(/ELASTICSEARCH_URL/).map do |k|
      Class.new(Mes::Elastic::Model) do
        config url: ENV[k], index: CHECK_AVAILABILITY_INDEX
        multitype
      end
    end

    # Check that cluster is available
    models.map(&:client).each(&method(:wait_for_being_available))

    models.each(&:create_index)

    models.each do |m|
      loop do
        # Check that index is created
        json = m.client.indices.get_settings(index: CHECK_AVAILABILITY_INDEX)
        next unless json[CHECK_AVAILABILITY_INDEX]

        # Check that shards are ready
        json = m.client.indices.shard_stores(index: CHECK_AVAILABILITY_INDEX)
        break if json.dig('indices', CHECK_AVAILABILITY_INDEX, 'shards').all? { |_, v| v['stores'].any? }
      end
    end

    @elastics_ready = true
  end

  def index_settings_for_one_shard
    { number_of_shards: 1, number_of_replicas: 0 }
  end

  def wait_for_being_available(client)
    20.times do
      begin
        break if client.ping
      rescue ::Elasticsearch::Transport::Transport::Errors::ServiceUnavailable, HTTPClient::KeepAliveDisconnected
        # do nothing, lets try one more time
      end
      sleep 0.5
    end
  end

  def flush_elastic_indices(client)
    client.indices.flush
    client.cluster.health(wait_for_status: 'yellow')
    wait_for_being_available(client)
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

  config.before(:all) { ElasticIndexHelpers.prepare_elastics }
end

if defined?(FactoryGirl)
  FactoryGirl.definition_file_paths << File.join(Mes::Elastic::ROOT, 'spec/factories/').to_s
end
