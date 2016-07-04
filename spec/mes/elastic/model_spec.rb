require 'spec_helper'

describe Mes::Elastic::Model do
  include_context 'with test indices'
  let(:subject) { test_model }
end
