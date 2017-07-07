require 'mes/elastic/model/elastic_api_methods'
require 'mes/elastic/model/mappings'
require 'mes/elastic/model/attributes'
require 'mes/elastic/model/lookup_methods'
require 'mes/elastic/model/crud_actions'
require 'mes/elastic/model/multitype'
require 'mes/elastic/model/errors'
require 'mes/elastic/model/language_analyzers'

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

      def initialize(attrs = {}, opts = {})
        raise IntatiatingModelWithoutTypeError if self.class.multitype?
        initialize_attributes
        initialize_save_actions(opts)
        assign_attributes(convert_attributes(attrs), opts)
      end
    end
  end
end
