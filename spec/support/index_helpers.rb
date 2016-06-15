module IndexHelpers
  def index_settings_for_one_shard
    { number_of_shards: 1, number_of_replicas: 0 }
  end
end

RSpec.configure do |config|
  config.include IndexHelpers
end
