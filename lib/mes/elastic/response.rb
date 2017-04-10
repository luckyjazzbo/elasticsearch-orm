module Mes
  module Elastic
    class Response
      include Enumerable
      attr_reader :model, :raw_data

      def initialize(model, raw_data)
        @model = model
        @raw_data = raw_data
      end

      def each
        hits.each do |hit|
          attributes = { 'id' => hit['_id'] }
          attributes.merge!(hit['_source']) if hit['_source']
          attributes.merge!(fields_attributes(hit['fields'])) if hit['fields']

          obj = model.build(
            hit['_type'],
            attributes,
            { ignore_mapping: true, persisted: true }
          )
          obj.persist!
          yield obj
        end
      end

      def total_count
        raw_data['hits']['total']
      end

      def empty?
        hits.empty?
      end

      def hits
        raw_data['hits']['hits']
      end

      private

      def fields_attributes(fields)
        fields.each_with_object({}) do |(k, v), attrs|
          *path, key = k.split('.')
          last_hash = path.inject(attrs) { |a, p| a[p] ||= {} }
          last_hash[key] = v
        end
      end
    end
  end
end
