module ElasticsearchOrm
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

      def define_object_accessors(field_name, current_mapping)
        if current_mapping[field_name].delete :array
          define_objects_array_accessors(field_name, current_mapping)
        else
          define_inplace_object_accessors(field_name, current_mapping)
        end
      end

      def define_inplace_object_accessors(field_name, current_mapping)
        define_method(field_name) do
          attributes[field_name] ||= {}
          ObjectField.new(attributes[field_name], current_mapping[field_name])
        end

        define_method("#{field_name}=") do |hash|
          # TODO: validate hash before updating the underlying structure
          assign_attribute(field_name, hash.deep_symbolize_keys!)
        end
      end

      def define_objects_array_accessors(field_name, current_mapping)
        define_method(field_name) do
          attributes[field_name] ||= []
          ObjectArrayField.new(attributes[field_name], current_mapping[field_name])
        end

        define_method("#{field_name}=") do |array|
          assign_attribute(field_name, array.map(&:deep_symbolize_keys!))
        end
      end
    end
  end
end
