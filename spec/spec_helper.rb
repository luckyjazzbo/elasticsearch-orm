$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
Dotenv.load('.env.test', '.env')

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |file| require file }

require 'mes_elastic'
