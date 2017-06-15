module Mes
  module Elastic
    class ObjectFieldDefiner
      include Model::MappingDsl

      def initialize(root_mapping, current_mapping_path)
        @root_mapping = root_mapping
        @current_mapping_path = current_mapping_path
      end

      private

      attr_reader :root_mapping, :current_mapping_path

      def validate_name!(name)
        raise UnpermittedFieldNameError unless allowed_field?(name)
      end

      def allowed_field?(name)
        !methods.include?(name)
      end

      def after_object_defined(_name, mapping)
        mapping.delete :array
      end

      # INFO: accesssor for the nested objects are defined in ObjectField
    end
  end
end
