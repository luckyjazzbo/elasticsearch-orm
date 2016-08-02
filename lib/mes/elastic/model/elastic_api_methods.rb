require 'elasticsearch'
require 'active_support/core_ext/hash'
require 'faraday_middleware/aws_signers_v4'

module Mes
  module Elastic
    class Model
      module ElasticAPIMethods
        attr_reader :url, :index_settings

        def config(opts = {})
          @url = opts[:url]                       if opts[:url].present?
          @index = opts[:index]                   if opts[:index].present?
          @index_settings = opts[:index_settings] if opts[:index_settings].present?
          @configured = true
        end

        def configured?
          @configured
        end

        # TODO: Maybe need some refactor?
        def client
          if configured?
            es_url = url || ENV.fetch('ELASTICSEARCH_URL')
            @client ||= aws_elastic_url?(es_url) ? aws_signed_client(es_url) : ::Elasticsearch::Client.new(url: es_url)
          else
            superclass.client
          end
        end

        def aws_signed_client(url)
          Elasticsearch::Client.new(url: url) do |f|
            f.request :aws_signers_v4,
                      credentials: Aws::InstanceProfileCredentials.new.credentials,
                      service_name: 'es',
                      region: fetch_region_from_aws_url(url)

            f.response :logger
            f.adapter  Faraday.default_adapter
          end
        end

        def aws_elastic_url?(url)
          url.end_with? '.es.amazonaws.com'
        end

        def fetch_region_from_aws_url(url)
          # http://blah-blah-blah.eu-west-1.es.amazonaws.com
          url.split('.')[-4]
        end

        def index
          @index || superclass.index
        end

        def index_exists?
          client.indices.exists?(index: index)
        end

        def create_index
          client.indices.create(index: index, body: { settings: index_settings || {} }) unless index_exists?
        end

        def drop_index!
          client.indices.delete(index: index) if index_exists?
        end

        def purge_index!
          drop_index!
          create_index
        end

        def create_mapping
          return if multitype?
          client.indices.put_mapping(
            index: index, type: type, body: { type => { properties: mapping } }
          )
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

        def delete(id)
          client.delete(index: index, type: type, id: id)
        end

        def delete_all
          drop_index!
          create_index
          create_mapping
        end
      end
    end
  end
end
