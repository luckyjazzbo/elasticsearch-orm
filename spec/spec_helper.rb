$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
Dotenv.load('.env.test', '.env')

require 'mes_elastic'
