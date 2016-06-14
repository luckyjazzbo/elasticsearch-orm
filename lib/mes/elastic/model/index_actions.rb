require 'elasticsearch'
require 'active_support/core_ext/hash'

module Mes
  module Elastic
    class Model
      module IndexActions
        attr_reader :url, :configured

        def config(opts = {})
          @url = opts[:url]
          @index = opts[:index]
          @configured = true
        end

        def client
          if configured
            @client ||= ::Elasticsearch::Client.new(url: ENV.fetch('ELASTICSEARCH_URL', url))
          else
            superclass.client
          end
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

        def save(attrs)
          opts = { index: index, type: type }
          opts[:id] = attrs[:id] if attrs.key? :id
          opts[:body] = attrs.except(:id)
          client.index(opts)['_id']
        end
      end
    end
  end
end
