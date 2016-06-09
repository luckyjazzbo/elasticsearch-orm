require 'lte_core/elasticsearch/version'
require 'lte_core/elasticsearch/model'

Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each { |file| require file }
