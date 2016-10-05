module Mes
  module Elastic
    class BoolGroup
      attr_reader :queries

      def initialize
        @queries = []
      end

      def query(query)
        queries << query
      end

      def range(field, filter)
        queries << {
          range: { field => filter }
        }
      end
    end
  end
end
