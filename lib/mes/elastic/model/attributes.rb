require 'elasticsearch'

module Mes
  module Elastic
    class Model
      module Attributes
        attr_reader :attributes

        def initalize_attributes
          @attributes ||= {}
        end

        def assign_attributes(attrs)
          attrs.each { |key, val| assign_attribute(key, val) }
        end

        def assign_attribute(key, value)
          raise UnpermittedAttributeException unless attribute?(key)
          @attributes[key.to_sym] = value
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
      end
    end
  end
end
