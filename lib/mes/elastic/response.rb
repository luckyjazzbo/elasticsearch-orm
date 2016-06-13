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
          yield model.build(
            hit['_type'],
            { 'id' => hit['_id'] }.merge(hit['_source'])
          )
        end
      end

      def empty?
        hits.empty?
      end

      def hits
        raw_data['hits']['hits']
      end
    end
  end
end
