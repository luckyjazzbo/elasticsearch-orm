require 'spec_helper'
require_relative 'model/index_actions'
require_relative 'model/lookup_methods'
require_relative 'model/mappings'
require_relative 'model/multitype_models'


describe Mes::Elastic::Model do
  include_context 'with test indices'
  let(:subject) { test_model }

  include_context 'index actions'
  include_context 'mappings'
  include_context 'lookup methods'
  include_context 'multitype models'
end
