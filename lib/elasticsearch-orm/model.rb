require 'elasticsearch-orm/model/elastic_api_methods'
require 'elasticsearch-orm/model/mappings'
require 'elasticsearch-orm/model/attributes'
require 'elasticsearch-orm/model/lookup_methods'
require 'elasticsearch-orm/model/crud_actions'
require 'elasticsearch-orm/model/multitype'
require 'elasticsearch-orm/model/errors'
require 'elasticsearch-orm/model/language_analyzers'

module ElasticsearchOrm
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
