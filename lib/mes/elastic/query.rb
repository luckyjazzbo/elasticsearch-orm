require_relative 'response'
require 'active_support/core_ext/object/deep_dup'

module Mes
  module Elastic
    class Query
      attr_reader :model, :body

      def initialize(model)
        @model = model
        @body = { query: {} }
      end

      def match(params)
        copy.tap do |query|
          query.body[:query][:match] = params
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

      protected

      attr_writer :body
    end
  end
end
