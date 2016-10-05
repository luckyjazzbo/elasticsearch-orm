module Mes
  module Elastic
    class SimpleQuery < Query
      include Matchers

      def all
        copy.tap do |query|
          query.body[:query][:matchAll] = {}
        end
      end

      def must(&block)
        to_bool_query(:must, &block)
      end

      def must_not(&block)
        to_bool_query(:must_not, &block)
      end

      def should(&block)
        to_bool_query(:should, &block)
      end

      private

      def add_matcher(query_body)
        copy.tap do |query|
          query.body[:query].deep_merge!(query_body)
        end
      end

      def to_bool_query(filter_type, &block)
        BoolQuery.new(model).tap do |query|
          query.must { |filter| filter.raw(body_matching_part) }
          query.body.merge!(body_arranging_part)
          query.send(filter_type, &block)
        end
      end
    end
  end
end
