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

      # INFO: accesssor for the nested objects are defined in ObjectField
    end
  end
end
