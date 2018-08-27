require 'elasticsearch-orm/model/mappings/mapping_accessor_helper'

module ElasticsearchOrm
  class ObjectField
    include ElasticsearchOrm::Model::MappingAccessorHelper

    attr_reader :attributes, :current_mapping

    def initialize(attributes, current_mapping)
      @attributes = attributes
      @current_mapping = current_mapping
      define_accessors
    end

    private

    alias_method :define_method, :define_singleton_method

    def define_accessors
      defined_fields.each do |field_name, field_opts|
        if object_field?(field_opts)
          define_object_accessors(field_name, current_mapping[:properties])
        else
          define_field_accessors(field_name)
        end
      end
    end

    def object_field?(field_opts)
      field_opts.key?(:properties)
    end

    def defined_fields
      current_mapping[:properties]
    end

    def assign_attribute(field_name, value)
      attributes[field_name] = value
    end
  end
end
