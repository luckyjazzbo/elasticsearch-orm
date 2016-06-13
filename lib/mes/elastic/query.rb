require_relative 'response'

module Mes
  module Elastic
    class Query
      attr_reader :model, :body

      def initialize(model)
        @model = model
        @body = { query: {} }
      end

      def match(params)
        @body[:query][:match] = params
      end

      def execute
        Response.new(model, model.search(body))
      end
    end
  end
end
