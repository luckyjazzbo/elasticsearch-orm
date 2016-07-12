module Mes
  module Elastic
    class ObjectFieldDefiner
      include ::Mes::Elastic::Model::MappingDsl

      private

      def validate_name!(name)
        raise UnpermittedFieldNameError unless allowed_field?(name)
      end

      def allowed_field?(name)
        !methods.include?(name)
      end

      def define_field_accessors(field_name)
        # INFO: accesssor for the nested objects are defined in ObjectField
      end

      def define_object_accessors(field_name)
        # INFO: accesssor for the nested objects are defined in ObjectField
      end
    end
  end
end
