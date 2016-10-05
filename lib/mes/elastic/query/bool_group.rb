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

      private

      def add_matcher(query)
        raw(query)
      end
    end
  end
end
