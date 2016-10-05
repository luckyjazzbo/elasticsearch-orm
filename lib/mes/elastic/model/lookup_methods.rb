require 'elasticsearch'
require_relative '../query'
require_relative '../bool_query'

module Mes
  module Elastic
    class Model
      module LookupMethods
        def count
          Query.new(self).all.limit(0).execute.total_count
        end

        def find(id)
          response = Query.new(self).match(_id: id).execute
          raise RecordNotFoundError if response.empty?
          response.first
        end

        def query(body = nil)
          Query.new(self, body: body)
        end

        def bool_query
          BoolQuery.new(self)
        end

        delegate :all, :match, to: :query
        delegate :must, :must_not, :should, to: :bool_query
      end
    end
  end
end
