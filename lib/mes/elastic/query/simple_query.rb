module Mes
  module Elastic
    class SimpleQuery < Query
      include Matchers

      def all
        copy.tap do |query|
          query.query_scope[:match_all] = {}
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

      def filter(&block)
        to_bool_query(:filter, &block)
      end

      private

      def add_query(query_body)
        copy.tap do |query|
          query.query_scope.deep_merge!(query_body)
        end
      end

      def add_filter(query_body)
        copy.tap do |query|
          query.filter_scope.deep_merge!(query_body)
        end
      end

      def to_bool_query(filter_type, &block)
        matching = body_matching_part
        BoolQuery.new(model).tap do |query|
          query.must { raw(matching) }
          query.body.merge!(body_arranging_part)
          query.send(filter_type, &block)
        end
      end
    end
  end
end
