module ElasticsearchOrm
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

    def must(&block)
      bool { must(&block) }
    end

    def must_not(&block)
      bool { must_not(&block) }
    end

    def all(&block)
      Kernel.warn 'DEPRECATION WARNING: `all` filter is deprecated, use `must` instead'
      must(&block)
    end

    def bool(&block)
      query = BoolQuery.new(self)
      query.instance_eval(&block)
      queries << query.body[:query]
    end

    private

    def add_query(query)
      raw(query)
    end

    alias_method :add_filter, :add_query
  end
end
