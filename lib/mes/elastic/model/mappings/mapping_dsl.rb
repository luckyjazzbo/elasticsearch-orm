module Mes
  module Elastic
    class Model
      module MappingDsl
        def mapping
          @mapping ||= {}
        end

        def field?(key)
          mapping.key? key.to_sym
        end

        def field(field_name, opts = {})
          field_name = field_name.to_sym
          return if field?(field_name)

          validate_name!(field_name)
          mapping[field_name] = opts
          run_callback(:after_field_defined, field_name)
        end

        # INFO: as a desired feature it would be nice
        #       to have extra checks for setters of arrays
        def array(field_name, opts = {}, &block)
          if opts[:type] == :object
            object(field_name, array: true, &block)
          else
            field(field_name, opts, &block)
          end
        end

        def object(field_name, opts = {}, &block)
          field_name = field_name.to_sym
          return if field?(field_name)

          validate_name!(field_name)
          mapping[field_name] = { properties: catch_object_mapping(&block), array: opts.fetch(:array, false) }
          run_callback(:after_object_defined, field_name)
        end

        private

        def catch_object_mapping(&block)
          ObjectFieldDefiner.new.tap do |definer|
            definer.instance_eval(&block)
          end.mapping
        end

        def validate_name!(name)
          raise NotImplementedError
        end

        def run_callback(callback_name, *args)
          send(callback_name, *args) if respond_to?(callback_name, true)
        end
      end
    end
  end
end
