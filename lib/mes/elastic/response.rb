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
          obj = model.build(
            hit['_type'],
            { 'id' => hit['_id'] }.merge(hit['_source']),
            { ignore_mapping: true, persisted: true }
          )
          obj.persist!
          yield obj
        end
      end

      def count
        hits.count
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

      def aggregations
        raw_data['aggregations'] || {}
      end

      def aggregation_buckets(aggregation_name = nil)
        if aggregation_name.present?
          aggregations.dig(aggregation_name, 'buckets')
        else
          aggregations.values.first.try(:[], 'buckets')
        end
      end
    end
  end
end
