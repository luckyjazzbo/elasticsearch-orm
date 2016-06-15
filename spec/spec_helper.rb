$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
Dotenv.load('.env.test', '.env')

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |file| require file }

require 'mes-elastic'

RSpec.configure do |config|
  config.before(:all) do
    Eva::Elastic::Resource.config(index_settings: index_settings_for_one_shard)
    Mes::Elastic::Resource.config(index_settings: index_settings_for_one_shard)
  end
end
