require 'elasticsearch'

module Mes
  module Elastic
    class Model
      module IndexActions
        attr_reader :type

        def config(opts = {})
          @client = ::Elasticsearch::Client.new(url: opts[:url] || ENV.fetch('ELASTICSEARCH_URL'))
          @index = opts[:index]
        end

        def client
          @client || superclass.client
        end

        def index
          @index || superclass.index
        end

        def index_exists?
          client.indices.exists?(index: index)
        end

        def create_index
          client.indices.create(index: index) unless index_exists?
        end

        def drop_index!
          client.indices.delete(index: index) if index_exists?
        end

        def purge_index!
          drop_index!
          create_index
        end

        def search(body)
          opts = { index: index, body: body }
          opts[:type] = type unless multitype?
          client.search(opts)
        end
      end
    end
  end
end
