$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'byebug'
require 'dotenv'
Dotenv.load('.env.test', '.env')
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |file| require file }
require 'factory_girl'
require 'webmock/rspec'

WebMock.disable_net_connect!(
  allow: [
    ENV['ELASTICSEARCH_URL'],
  ]
)

require 'mes-elastic'

FactoryGirl.find_definitions
