require 'mes/elastic/model'

module Mes
  module Elastic
    class EVA < Model
      set_index 'lte', url: ENV['EVA_ELASTICSEARCH_URL']
    end
  end
end
