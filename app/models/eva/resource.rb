module Eva
  module Elastic
    class Resource < Mes::Elastic::Model
      config url: ENV['ELASTICSEARCH_URL'], index: 'eva'
      multitype
    end
  end
end
