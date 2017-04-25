module ContentApi
  module Elastic
    class Resource < Mes::Elastic::Model
      config url: ENV['CONTENT_API_ELASTICSEARCH_URL'], index: 'lte'
      multitype
    end
  end
end
