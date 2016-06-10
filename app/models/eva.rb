require 'mes/elastic/model'

module Mes
  module Elastic
    class EVA < Model
      connect url: ENV['EVA_ELASTICSEARCH_URL'], index: 'lte'
    end
  end
end
