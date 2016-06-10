require 'mes/elastic/model'

module Mes
  class EvaIndex < Elastic::Model
    set_index 'lte', url: ENV['EVA_ELASTICSEARCH_URL']
  end
end
