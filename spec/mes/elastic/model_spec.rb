require 'spec_helper'
require_relative 'model/elastic_api_methods'
require_relative 'model/lookup_methods'
require_relative 'model/mappings'
require_relative 'model/multitype_models'
require_relative 'model/crud_actions'

describe Mes::Elastic::Model do
  include_context 'with test indices'
  let(:subject) { test_model }

  include_context 'elastic api methods'
  include_context 'mappings'
  include_context 'lookup methods'
  include_context 'multitype models'
  include_context 'CRUD actions'
end
