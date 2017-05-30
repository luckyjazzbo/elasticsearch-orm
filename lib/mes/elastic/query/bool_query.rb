module Mes
  module Elastic
    class BoolQuery < Query
      def find(id)
        response = filter { ids(id) }.execute
        raise RecordNotFoundError if response.empty?
        response.first
      end

      def must(&block)
        add_group(:must, &block)
      end

      def must_not(&block)
        add_group(:must_not, &block)
      end

      def should(&block)
        add_group(:should, &block)
      end

      def filter(&block)
        add_group(:filter, &block)
      end

      protected

      def add_group(filter_type, &block)
        group = BoolGroup.new

        if block.arity == 1
          block.call(group)
        else
          group.instance_eval(&block)
        end

        body[:query][:bool] ||= {}
        body[:query][:bool][filter_type] ||= []
        body[:query][:bool][filter_type] += group.queries

        self
      end
    end
  end
end
