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
          @attributes[key.to_sym] = value.is_a?(Hash) ? value.deep_symbolize_keys : value
        end
      end
    end
  end
end
