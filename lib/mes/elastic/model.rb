require_relative 'model/index_actions'
require_relative 'model/mappings'
require_relative 'model/attributes'
require_relative 'model/lookup_methods'
require_relative 'model/save_actions'
require_relative 'model/multitype'
require_relative 'model/errors'

module Mes
  module Elastic
    class Model
      extend IndexActions
      extend Mappings
      extend LookupMethods
      extend Multitype
      extend SaveActionsClassMethods
      include Attributes
      include SaveActions

      def initialize(attrs = {})
        raise IntatiatingModelWithoutType if self.class.multitype?
        initialize_attributes
        initialize_save_actions
        assign_attributes(attrs)
      end
    end
  end
end
