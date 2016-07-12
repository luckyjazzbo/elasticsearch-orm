module Mes
  module Elastic
    class Model
      module MappingAccessorHelper
        def define_field_accessors(field_name)
          define_method(field_name) do
            attributes[field_name]
          end

          define_method("#{field_name}=") do |value|
            assign_attribute(field_name, value)
          end
        end

        def define_object_accessors(field_name, mapping)
          define_method(field_name) do
            attributes[field_name] ||= {}
            ObjectField.new(attributes[field_name], mapping[field_name])
          end

          define_method("#{field_name}=") do |hash|
            # TODO: validate hash before updating the underlying structure
            assign_attribute(field_name, hash.deep_symbolize_keys!)
          end
        end
      end
    end
  end
end
