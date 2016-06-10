require 'elasticsearch'

module Mes
  module Elastic
    class Model
      module ClassMethods
        attr_reader :client, :index

        def set_index(index, opts = {})
          @client = ::Elasticsearch::Client.new(url: opts[:url] || ENV.fetch('ELASTICSEARCH_URL'))
          @index = index
        end

        def index_exists?
          client.indices.exists?(index: index)
        end

        def create_index
          client.indices.create(index: index) unless index_exists?
        end
      end
    end
  end
end
