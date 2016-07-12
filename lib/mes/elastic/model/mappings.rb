require 'elasticsearch'
require_relative 'mappings/mapping_accessor_helper'
require_relative 'mappings/mapping_dsl'
require_relative 'mappings/object_field_definer'
require_relative 'mappings/object_field'

module Mes
  module Elastic
    class Model
      module Mappings
        include ::Mes::Elastic::Model::MappingAccessorHelper
        include ::Mes::Elastic::Model::MappingDsl

        def mapping
          @mapping ||= { id: { type: :string, index: :not_analyzed } }
        end

        private

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

        def after_object_defined(field_name)
          define_object_accessors(field_name, mapping)
        end
      end
    end
  end
end
