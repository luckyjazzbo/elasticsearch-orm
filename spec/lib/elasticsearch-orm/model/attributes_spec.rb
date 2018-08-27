require 'spec_helper'

RSpec.describe 'Attributes' do
  include_context 'with test indices'
  let(:subject) { test_model }

  context 'accessing with string keys' do
    let(:object) { test_model.new(test_field: { key1: 'val1' }) }

    before do
      test_model.field :test_field
    end

    it 'allows to access attributes by string keys' do
      expect(object.test_field['key1']).to eq('val1')
    end
  end

  context 'accessing with symbolic keys' do
    let(:object) { test_model.new('test_field' => { 'key2' => 'val2' }) }

    before do
      test_model.field :test_field
    end

    it 'allows to access attributes by string keys' do
      expect(object.test_field[:key2]).to eq('val2')
    end
  end
end
