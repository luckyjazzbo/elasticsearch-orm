module Mes
  module Elastic
    class BoolGroup
      include Matchers

      attr_reader :queries

      def initialize
        @queries = []
      end

      def raw(query)
        queries << query
      end

      def any(&block)
        group = BoolGroup.new
        group.instance_eval(&block)

        queries << {
          bool: {
            should: group.queries,
            minimum_should_match: 1
          }
        }
      end

      private

      def add_query(query)
        raw(query)
      end

      alias_method :add_filter, :add_query
    end
  end
end
