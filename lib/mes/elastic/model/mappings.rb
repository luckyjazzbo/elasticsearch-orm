require 'elasticsearch'
require_relative 'mappings/mapping_accessor_helper'
require_relative 'mappings/mapping_dsl'
require_relative 'mappings/object_field_definer'
require_relative 'mappings/object_field'
require_relative 'mappings/object_array_field'

module Mes
  module Elastic
    class Model
      module Mappings
        include ::Mes::Elastic::Model::MappingAccessorHelper
        include ::Mes::Elastic::Model::MappingDsl

        def mapping
          @mapping ||= { dynamic_templates: [], properties: { id: { type: :keyword } } }
        end

        private

        def current_mapping
          mapping[:properties]
        end

        def current_mapping_path
          []
        end

        def root_mapping
          mapping
        end

        def validate_name!(name)
          raise SettingFieldsForModelWithoutTypeError if multitype?
          raise UnpermittedFieldNameError unless allowed_field?(name)
        end

        def allowed_field?(name)
          !instance_methods.include?(name)
        end

        def after_field_defined(field_name)
          define_field_accessors(field_name)
        end

        def after_object_defined(field_name, _mapping)
          define_object_accessors(field_name, current_mapping)
        end
      end
    end
  end
end
