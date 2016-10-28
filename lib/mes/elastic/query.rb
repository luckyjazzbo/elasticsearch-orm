module Mes
  module Elastic
    class Query
    end
  end
end

require_relative 'response'
require_relative 'query/matchers'
require_relative 'query/bool_group'
require_relative 'query/bool_query'
require_relative 'query/simple_query'
require 'active_support/core_ext/object/deep_dup'

module Mes
  module Elastic
    class Query
      attr_accessor :model, :body
      include Enumerable

      def initialize(model, args = {})
        @model = model
        @body = args[:body]&.symbolize_keys || default_body
      end

      def order(order)
        copy.tap do |query|
          query.body[:sort] = parse_order(order)
        end
      end

      def offset(count)
        copy.tap do |query|
          query.body[:from] = count
        end
      end

      def limit(count)
        copy.tap do |query|
          query.body[:size] = count
        end
      end

      def execute
        Response.new(model, model.search(body))
      end

      def copy
        dup.tap do |query|
          query.body = body.deep_dup
          query
        end
      end

      def count
        execute.total_count
      end

      def each(&block)
        execute.each(&block)
      end

      protected

      def query_scope
        body[:query][:filtered] ||= { query: {} }
        body[:query][:filtered][:query]
      end

      def filter_scope
        body[:query][:filtered] ||= { filter: {} }
        body[:query][:filtered][:filter]
      end

      def default_body
        { query: {} }
      end

      def body_matching_part
        body.slice(:query, :filtered)
      end

      def body_arranging_part
        body.except(:query, :filtered)
      end

      def parse_order(order)
        order.strip.split(',').map do |order_step|
          single_ordering = order_step.strip.split(/\s+/)
          { single_ordering[0] => { order: single_ordering[1] || 'asc' } }
        end
      end
    end
  end
end
