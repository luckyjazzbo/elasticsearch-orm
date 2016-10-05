require_relative 'bool_group'

module Mes
  module Elastic
    class BoolQuery < Query
      def must(&block)
        add_group(:must, &block)
      end

      def must_not(&block)
        add_group(:must_not, &block)
      end

      def should(&block)
        add_group(:should, &block)
      end

      protected

      def add_group(type)
        group = BoolGroup.new
        yield group

        body[:query][:bool] ||= {}
        body[:query][:bool][type] ||= []
        body[:query][:bool][type] += group.queries

        self
      end
    end
  end
end
