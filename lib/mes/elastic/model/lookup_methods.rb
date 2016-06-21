require 'elasticsearch'
require_relative '../query'

module Mes
  module Elastic
    class Model
      module LookupMethods
        def count
          Query.new(self).all.limit(0).execute.total_count
        end

        def find(id)
          response = Query.new(self).match(_id: id).execute
          raise RecordNotFoundException if response.empty?
          response.first
        end

        def query
          Query.new(self)
        end

        delegate :all, to: :query
      end
    end
  end
end
