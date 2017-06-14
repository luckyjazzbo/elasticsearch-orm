module Mes
  module Elastic
    class Resource < Model
      config url: ENV['ELASTICSEARCH_URL'], index: 'mes'
      multitype
    end
  end
end
