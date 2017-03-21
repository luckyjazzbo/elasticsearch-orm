require 'elasticsearch'
require 'active_support/core_ext/hash'
require 'faraday_middleware/aws_signers_v4'

module Mes
  module Elastic
    class Model
      module ElasticAPIMethods
        attr_reader :url

        def config(opts = {})
          @url = opts[:url]                       if opts[:url].present?
          @index = opts[:index]                   if opts[:index].present?
          if opts[:index_settings].present?
            @index_settings = opts[:index_settings].merge(@index_settings || {})
          end
          @configured = true
        end

        def configured?
          @configured
        end

        def client
          if configured?
            es_url = url || ENV.fetch('ELASTICSEARCH_URL')
            @client ||= aws_elastic_url?(es_url) ? aws_signed_client(es_url) : aws_unsigned_url(es_url)
          else
            superclass.client
          end
        end

        def aws_signed_client(url)
          Elasticsearch::Client.new(url: url) do |f|
            f.request :aws_signers_v4,
                      credentials: Aws::InstanceProfileCredentials.new,
                      service_name: 'es',
                      region: fetch_region_from_aws_url(url)
            f.adapter Faraday.default_adapter
          end
        end

        def aws_unsigned_url(url)
          Elasticsearch::Client.new(url: url)
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

        def index_settings
          @index_settings || superclass.try(:index_settings) || {}
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
          # Warning! Use with caution, very slow! Can be used only in tests!
          bulk_queue = search(query: { matchAll: {} }, size: 1000)['hits']['hits'].map do |record|
            { "delete" => { "_index" => index, "_type" => record['_type'], "_id" => record['_id'] } }
          end
          return if bulk_queue.empty?
          client.bulk(body: bulk_queue)
        end
      end
    end
  end
end
