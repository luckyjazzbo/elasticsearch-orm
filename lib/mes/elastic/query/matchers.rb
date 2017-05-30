module Mes
  module Elastic
    module Matchers
      def ids(ids)
        add_query(ids: { values: Array(ids) })
      end

      def match(field, value = nil)
        if field.is_a?(Hash)
          add_query(match: field)
        else
          add_query(match: { field => value })
        end
      end

      def terms(field, values)
        if values.respond_to?(:each)
          add_filter(terms: { field => Array(values) })
        elsif values.nil?
          add_filter(missing: { field: field })
        else
          add_filter(term: { field => values })
        end
      end

      def range(field, filter)
        add_filter(range: { field => filter })
      end

      def add_query(query)
        raise NotImplementedError, 'add_query must be implemented in children'
      end

      def add_filter(query)
        raise NotImplementedError, 'add_filter must be implemented in children'
      end
    end
  end
end
