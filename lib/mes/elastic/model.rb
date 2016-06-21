require_relative 'model/elastic_api_methods'
require_relative 'model/mappings'
require_relative 'model/attributes'
require_relative 'model/lookup_methods'
require_relative 'model/crud_actions'
require_relative 'model/multitype'
require_relative 'model/errors'

module Mes
  module Elastic
    class Model
      extend ElasticAPIMethods
      extend Mappings
      extend LookupMethods
      extend Multitype
      extend CRUDActionsClassMethods
      include Attributes
      include CRUDActions

      def initialize(attrs = {})
        raise IntatiatingModelWithoutType if self.class.multitype?
        initialize_attributes
        initialize_save_actions
        assign_attributes(attrs)
      end
    end
  end
end
