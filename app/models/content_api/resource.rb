module ContentApi
  module Elastic
    class Resource < Mes::Elastic::Model
      config url: ENV['ELASTICSEARCH_URL'], index: 'api'
      multitype
    end
  end
end
