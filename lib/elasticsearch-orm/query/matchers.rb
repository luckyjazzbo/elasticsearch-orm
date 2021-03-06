module ElasticsearchOrm
  module Matchers
    def ids(ids)
      add_filter(ids: { values: Array(ids) })
    end

    def match(field, value = nil)
      if field.is_a?(Hash)
        add_query(match: field)
      else
        add_query(match: { field => value })
      end
    end

    def multi_match(opts)
      add_query(multi_match: opts)
    end

    def terms(field, values)
      if values.respond_to?(:each)
        add_filter(terms: { field => Array(values) })
      elsif values.nil?
        bool do
          must_not do
            add_filter(exists: { field: field })
          end
        end
      else
        add_filter(term: { field => values })
      end
    end

    def range(field, filter)
      add_filter(range: { field => filter })
    end

    def add_query(query)
      raise NotImplementedError, 'add_query must be implemented in a child'
    end

    def add_filter(query)
      raise NotImplementedError, 'add_filter must be implemented in a child'
    end
  end
end
