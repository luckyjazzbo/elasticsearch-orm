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
          query = Query.new(self)
          query.match(_id: id)
          response = query.execute
          raise RecordNotFoundException if response.empty?
          response.first
        end
      end
    end
  end
end
