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

      def add_group(filter_type, &block)
        group = BoolGroup.new
        group.instance_eval(&block)

        body[:query][:bool] ||= {}
        body[:query][:bool][filter_type] ||= []
        body[:query][:bool][filter_type] += group.queries

        self
      end
    end
  end
end
