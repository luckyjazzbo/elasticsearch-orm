module Mes
  module Elastic
    class BoolQuery < Query
      def find(id)
        response = filter { ids(id) }.execute
        raise Model::RecordNotFoundError if response.empty?
        response.first
      end

      def must(opts = {}, &block)
        add_group(:must, opts, &block)
      end

      def must_not(opts = {}, &block)
        add_group(:must_not, opts, &block)
      end

      def should(opts = {}, &block)
        add_group(:should, opts, &block)
      end

      def filter(opts = {}, &block)
        add_group(:filter, opts, &block)
      end

      protected

      def add_group(filter_type, opts = {}, &block)
        group = BoolGroup.new

        if block.arity == 1
          block.call(group)
        else
          group.instance_eval(&block)
        end

        body[:query][:bool] ||= {}
        body[:query][:bool].merge!(prepare_options(opts))
        body[:query][:bool][filter_type] ||= []
        body[:query][:bool][filter_type] += group.queries

        self
      end

      def prepare_options(opts)
        opts[:minimum_should_match] = opts.delete(:min_match) if opts.key?(:min_match)
        opts
      end
    end
  end
end
