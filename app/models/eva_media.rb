module Eva
  module Elastic
    class Media < ::Mes::Elastic::Model
      config url: ENV['EVA_ELASTICSEARCH_URL'], index: 'lte'
      multitype
    end
  end
end
