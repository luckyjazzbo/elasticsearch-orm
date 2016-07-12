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
          subclass.setup_parent
        end

        def multitype
          @multitype = true
          @descendants = {}
        end

        def multitype?
          @multitype
        end

        def type
          return nil if multitype?
          @type ||= to_s.demodulize.underscore
        end

        protected

        attr_accessor :descendants

        def class_by_type(document_type)
          return self if type && type == document_type
          return descendants[document_type] if descendants.key? document_type
          raise UnknownTypeError
        end

        def setup_parent
          return if multitype?
          superclass.descendants[type] = self if superclass.multitype?
        end
      end
    end
  end
end
