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
          if order.nil?
            query.body.delete(:sort)
          else
            query.body[:sort] = parse_order(order)
          end
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

      def select(fields)
        copy.tap do |query|
          query.body[:_source] = fields
        end
      end

      def execute
        @response ||= Response.new(model, model.search(body))
      end

      def copy
        dup.tap do |query|
          query.remove_instance_variable(:@response) if query.instance_variable_defined?(:@response)
          query.body = body.deep_dup
        end
      end

      def total_count
        execute.total_count
      end

      def count
        Kernel.warn "DEPRECATED: Use total_count instead of count"
        total_count
      end

      def size
        execute.count
      end

      def each(&block)
        execute.each(&block)
      end

      protected

      def query_scope
        body[:query][:bool] ||= { must: {} }
        body[:query][:bool][:must]
      end

      def filter_scope
        body[:query][:bool] ||= { filter: {} }
        body[:query][:bool][:filter]
      end

      def default_body
        { query: {} }
      end

      def body_matching_part
        body.slice(:query, :bool)
      end

      def body_arranging_part
        body.except(:query, :bool)
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
