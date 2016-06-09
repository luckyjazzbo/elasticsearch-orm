require 'lte_core/elasticsearch/model'

module LteCore
  module Elasticsearch
    class EVA < Model
      connect url: ENV['EVA_ELASTICSEARCH_URL'], index: 'lte'
    end
  end
end
