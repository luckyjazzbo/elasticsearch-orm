require 'mes/elastic/version'
require 'mes/elastic/model'

Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each { |file| require file }
