require_relative 'model/index_actions'
require_relative 'model/mappings'
require_relative 'model/attributes'
require_relative 'model/lookup_methods'
require_relative 'model/multitype'
require_relative 'model/errors'

module Mes
  module Elastic
    class Model
      extend IndexActions
      extend Mappings
      extend LookupMethods
      extend Multitype
      include Attributes

      def initialize(attrs = {})
        raise IntatiatingModelWithoutType if self.class.multitype?
        initalize_attributes
        assign_attributes(attrs)
      end
    end
  end
end
