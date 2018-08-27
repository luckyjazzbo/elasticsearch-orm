module ElasticsearchOrm
  class SimpleQuery < Query
    include Matchers

    def all
      copy.tap do |query|
        query.query_scope[:match_all] = {}
      end
    end

    def find(id)
      to_bool_query.find(id)
    end

    def must(opts = {}, &block)
      to_bool_query(:must, opts, &block)
    end

    def must_not(opts = {}, &block)
      to_bool_query(:must_not, opts, &block)
    end

    def should(opts = {}, &block)
      to_bool_query(:should, opts, &block)
    end

    def filter(opts = {}, &block)
      to_bool_query(:filter, opts, &block)
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

    def to_bool_query(filter_type = nil, opts = {}, &block)
      matching = body_matching_part[:query]
      BoolQuery.new(model).tap do |query|
        query.must { raw(matching) }
        query.body.merge!(body_arranging_part)
        query.send(filter_type, opts, &block) if filter_type
      end
    end

    def bool(&block)
      query = BoolQuery.new(self)
      query.instance_eval(&block)
      add_filter query.body[:query]
    end
  end
end
