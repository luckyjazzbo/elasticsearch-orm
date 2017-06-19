require 'elasticsearch'

module Mes
  module Elastic
    class Model
      module Attributes
        attr_reader :attributes

        def initialize_attributes
          @attributes ||= {}.with_indifferent_access
        end

        def assign_attributes(attrs, opts = {})
          attrs.each { |key, val| generic_assign_attribute(key, val, !opts[:ignore_mapping]) }
        end

        def assign_attribute(key, value)
          generic_assign_attribute(key, value)
        end

        def attribute?(key)
          self.class.field? key
        end

        def id
          attributes[:id]
        end

        def id=(val)
          assign_attribute(:id, val)
        end

        private

        def generic_assign_attribute(key, value, respect_mapping = true)
          if respect_mapping
            raise UnpermittedAttributeError, "Attribute '#{key}' is not permitted" unless attribute?(key)
          end

          @attributes[key.to_sym] = case value
          when Hash
            value.deep_symbolize_keys
          when ActiveSupport::TimeWithZone
            value.to_time
          else
            value
          end
        end

        def convert_attributes(attributes, mapping = self.class.mapping[:properties])
          l = lambda do |(k, v)|
            k_sym = k.to_sym

            return [k, v] unless mapping && (field_mapping = mapping[k_sym])

            value = if v.is_a?(Hash)
              convert_attributes(v, field_mapping[:properties])
            elsif field_mapping[:type] == :date
              parser = field_mapping[:format] == MappingDsl::DATETIME_FORMAT ? Time : Date
              return unless v
              v.is_a?(parser) ? v : parser.parse(v)
            else
              v
            end

            [k, value]
          end

          attributes.map(&l).to_h
        end
      end
    end
  end
end
