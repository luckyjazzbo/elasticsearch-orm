require 'lte_core/elasticsearch/model'

module LteCore
  module Elasticsearch
    class MES < Model
      connect url: ENV['MES_ELASTICSEARCH_URL'], index: 'lte'
    end
  end
end
