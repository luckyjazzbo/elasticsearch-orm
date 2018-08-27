require 'elasticsearch'
require 'active_support/core_ext/hash'
require 'faraday_middleware/aws_signers_v4'

module ElasticsearchOrm
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

      def def_filter(name, settings)
        index_settings[:analysis] ||= {}
        index_settings[:analysis][:filter] ||= {}
        index_settings[:analysis][:filter][name] = settings
      end

      def def_analyzer(name, settings)
        index_settings[:analysis] ||= {}
        index_settings[:analysis][:analyzer] ||= {}
        index_settings[:analysis][:analyzer][name] = settings
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
        @index_settings ||= superclass.try(:index_settings) || {}
      end

      def type_exists?
        with_error_convertion do
          client.indices.exists_type?(index: index, type: type)
        end
      end

      def index_exists?(index_name = index)
        with_error_convertion do
          client.indices.exists?(index: index_name)
        end
      end

      def create_index!
        with_error_convertion do
          client.indices.create(index: index, body: { settings: index_settings || {} }) unless index_exists?
        end
      end

      def create_index(index_name: nil, body: { settings: index_settings || {} })
        if index_name.nil?
          index_name = "#{index}-#{Time.now.strftime('%Y%m%d%H%M%S')}"
          puts "Generated index_name: #{index_name}"
        end

        with_error_convertion do
          client.indices.create(index: index_name, body: body)

          unless client.indices.exists_alias(name: index)
            create_alias(index_name)
          end
        end
      end

      def setup_index
        create_index
        create_mapping
      end

      def create_alias(index_name)
        with_error_convertion do
          client.indices.put_alias(name: index, index: index_name)
        end
      end

      def delete_alias(index_name)
        with_error_convertion do
          client.indices.delete_alias(name: index, index: index_name)
        end
      end

      def switch_alias(to_index)
        return create_alias(to_index) unless index_exists?

        from_index = client.indices.get_alias(name: index).keys.first

        with_error_convertion do
          client.indices.update_aliases(
            body: {
              actions: [
                { remove: { index: from_index, alias: index } },
                { add:    { index: to_index, alias: index } },
              ],
            }
          )
        end
      end

      def delete_index!(index_name: index)
        with_error_convertion do
          client.indices.delete(index: index_name) if index_exists?(index_name)
        end
      end

      def purge_index!
        delete_index!
        create_index!
      end

      def create_mapping
        return if multitype?
        with_error_convertion do
          client.indices.put_mapping(
            index: index, type: type, body: { type => mapping }
          )
        end
      end

      def search(body)
        opts = { index: index, body: body }
        opts[:type] = type unless multitype?
        with_error_convertion do
          client.search(opts)
        end
      end

      def save(attrs, opts = {})
        opts = { index: index, type: type, **opts }
        opts[:id] = attrs[:id] if attrs.key? :id
        opts[:body] = attrs
        with_error_convertion do
          client.index(opts)['_id']
        end
      end

      def delete(id)
        with_error_convertion do
          client.delete(index: index, type: type, id: id)
        end
      end

      def delete_all
        # Warning! Use with caution, very slow! Can be used only in tests!
        bulk_queue = search(size: 1000)['hits']['hits'].map do |record|
          { "delete" => { "_index" => index, "_type" => record['_type'], "_id" => record['_id'] } }
        end
        return if bulk_queue.empty?
        with_error_convertion do
          client.bulk(body: bulk_queue)
        end
      end
    end
  end
end
