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

        if block.arity == 1
          block.call(group)
        else
          group.instance_eval(&block)
        end

        queries << {
          bool: {
            should: group.queries,
            minimum_should_match: 1
          }
        }
      end

      %i(must must_not should filter).each do |method|
        define_method(method) do |&block|
          query = BoolQuery.new(self).public_send(method, &block)
          queries << query.body[:query]
        end
      end

      private

      def add_query(query)
        raw(query)
      end

      alias_method :add_filter, :add_query
    end
  end
end
