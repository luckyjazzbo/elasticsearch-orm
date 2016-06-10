require 'mes/elastic/model'

module Mes
  module Elastic
    class MES < Model
      set_index 'lte', url: ENV['MES_ELASTICSEARCH_URL']
    end
  end
end
