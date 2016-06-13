require 'active_support/core_ext/string/inflections'

module Mes
  module Elastic
    class Model
      module Multitype
        def build(document_type, attrs)
          class_by_type(document_type).new(attrs)
        end

        def inherited(subclass)
          super
          subclass.setup_type unless subclass.multitype?
        end

        def multitype
          @multitype = true
        end

        def multitype?
          @multitype
        end

        protected

        attr_accessor :descendants

        def class_by_type(document_type)
          return self if type && type == document_type
          return descendants[document_type] if descendants.key? document_type
          raise UnknownTypeException
        end

        def setup_type
          @type = to_s.demodulize.underscore
          setup_parent
        end

        def setup_parent
          superclass.descendants ||= {}
          superclass.descendants[type] = self
        end
      end
    end
  end
end
