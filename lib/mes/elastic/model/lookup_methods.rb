require 'elasticsearch'
require_relative '../query'

module Mes
  module Elastic
    class Model
      module LookupMethods
        def count
          all.limit(0).execute.total_count
        end

        def find(id)
          response = match(_id: id).execute
          raise RecordNotFoundError if response.empty?
          response.first
        end

        def query(body = nil)
          Kernel.warn 'DEPRICATION WARNING: Mes::Elastic::Model: .query is depricated. Use .raw instead'
          raw(body)
        end

        def raw(body)
          SimpleQuery.new(self, body: body)
        end

        def simple_query
          SimpleQuery.new(self)
        end

        def bool_query
          BoolQuery.new(self)
        end

        delegate :all, :match, :terms, :range,
                 to: :simple_query
        delegate :must, :must_not, :should, :filter,
                 to: :bool_query
      end
    end
  end
end
