require 'mes/elastic/model/mappings/mapping_accessor_helper'

module Mes
  module Elastic
    class ObjectField
      include ::Mes::Elastic::Model::MappingAccessorHelper

      attr_reader :attributes, :mapping

      def initialize(attributes, mapping)
        @attributes = attributes
        @mapping = mapping
        define_accessors
      end

      private

      alias_method :define_method, :define_singleton_method

      def define_accessors
        defined_fields.each do |field_name, field_opts|
          if object_field?(field_opts)
            define_object_accessors(field_name, mapping[:properties])
          else
            define_field_accessors(field_name)
          end
        end
      end

      def object_field?(field_opts)
        field_opts.key?(:properties)
      end

      def defined_fields
        mapping[:properties]
      end

      def assign_attribute(field_name, value)
        attributes[field_name] = value
      end
    end
  end
end
