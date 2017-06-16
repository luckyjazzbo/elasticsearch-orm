module Mes
  module Elastic
    class Model
      module MappingDsl
        DATETIME_FORMAT = 'yyyy-MM-dd HH:mm:ss ZZ'.freeze

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
          mapping[field_name] = transform_mapping(opts)
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
          run_callback(:after_object_defined, field_name, mapping[field_name])
        end

        def multilang_field(name, opts)
          raise LangsNotSetForMultilangFieldError unless const_defined?(:LANGS)

          langs = self::LANGS
          object name do
            langs.each do |lang|
              field lang, opts
            end
          end
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

        def transform_mapping(type_or_opts)
          type_or_opts = { type: type_or_opts } unless type_or_opts.is_a?(Hash)

          if type_or_opts[:type] == :datetime
            type_or_opts[:type] = :date
            type_or_opts[:format] = DATETIME_FORMAT
          end

          type_or_opts
        end
      end
    end
  end
end
