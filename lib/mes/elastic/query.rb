require_relative 'response'
require 'active_support/core_ext/object/deep_dup'

module Mes
  module Elastic
    class Query
      attr_reader :model, :body
      include Enumerable

      def initialize(model)
        @model = model
        @body = { query: {} }
      end

      def match(params)
        copy.tap do |query|
          query.body[:query][:match] = params
        end
      end

      def order(order)
        copy.tap do |query|
          query.body[:sort] = parse_order(order)
        end
      end

      def limit(count)
        copy.tap do |query|
          query.body[:size] = count
        end
      end

      def all
        copy.tap do |query|
          query.body[:query][:matchAll] = {}
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

      attr_writer :body

      def parse_order(order)
        order.strip.split(',').map do |order_step|
          single_ordering = order_step.strip.split(/\s+/)
          { single_ordering[0] => { 'order' => single_ordering[1] || 'asc' } }
        end
      end
    end
  end
end
