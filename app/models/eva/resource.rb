module Eva
  module Elastic
    class Resource < Mes::Elastic::Model
      config url: ENV['EVA_ELASTICSEARCH_URL'], index: 'lte'
      multitype
    end
  end
end
