require 'mes/elastic/model'

module Mes
  module Elastic
    class MES < Model
      connect url: ENV['MES_ELASTICSEARCH_URL'], index: 'lte'
    end
  end
end
