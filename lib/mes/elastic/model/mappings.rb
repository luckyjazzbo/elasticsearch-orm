require 'elasticsearch'

module Mes
  module Elastic
    class Model
      module Mappings
        def mapping
          @mapping ||= { id: :string }
        end

        def field?(key)
          mapping.key? key.to_sym
        end

        def field(field_name, type_cast = :string)
          field_name = field_name.to_sym
          return if field?(field_name)
          validate_field!(field_name)
          @mapping[field_name] = type_cast
          define_accessors(field_name, type_cast)
        end

        private

        def validate_field!(field_name)
          raise SettingFieldsForModelWithoutTypeException if multitype?
          raise UnpermittedFieldNameException unless allowed_field?(field_name)
        end

        def allowed_field?(field_name)
          !instance_methods.include? field_name
        end

        def define_accessors(field_name, _type_cast)
          define_method(field_name) { attributes[field_name] }
          define_method("#{field_name}=") do |value|
            assign_attribute(field_name, value)
          end
        end
      end
    end
  end
end
