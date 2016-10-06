module Mes
  module Elastic
    module Matchers
      def match(field, value = nil)
        if field.is_a?(Hash)
          add_matcher(match: field)
        else
          add_matcher(match: { field => value })
        end
      end

      def terms(field, values)
        if values.respond_to?(:each)
          add_matcher(terms: { field => Array(values) })
        else
          add_matcher(term: { field => values })
        end
      end

      def range(field, filter)
        add_matcher(range: { field => filter })
      end

      def add_matcher(query)
        raise NotImplementedError, 'add_matcher must be implemented in children'
      end
    end
  end
end
