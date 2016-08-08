require 'mes/elastic/model/mappings/mapping_accessor_helper'

module Mes
  module Elastic
    class ObjectArrayField
      include Enumerable
      attr_reader :mapping, :attributes

      def initialize(array, mapping)
        @mapping = mapping
        @attributes = array
      end

      def <<(value)
        attributes << value
      end

      def [](key)
        ObjectField.new(attributes[key], mapping)
      end

      def each(&block)
        attributes.each.with_index { |_, i| yield self[i] }
      end

      def []=(key, value)
        attributes[key] = value
      end
    end
  end
end