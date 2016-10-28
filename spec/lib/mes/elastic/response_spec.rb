require 'spec_helper'

RSpec.describe Mes::Elastic::Response do
  include_context 'with test indices'

  before do
    test_model.field(:title)
  end

  let(:mocked_response) do
    {
      'took' => 12,
      'timed_out' => false,
      '_shards' => { 'total' => 5, 'successful' => 5, 'failed' => 0 },
      'hits' => {
        'total' => 10,
        'max_score' => 1.0,
        'hits' => [
          {
            '_index' => 'elastic_index',
            '_type' => 'test_model',
            '_id' => '9084eddf-4a48-4e39-afbd-6f3e4e4dc7c5',
            '_score' => 1.0,
            '_source' => {
              'title' => 'Test 1'
            }
          },
          {
            '_index' => 'elastic_index',
            '_type' => 'test_model',
            '_id' => '6ee40a2c-3980-450a-b075-d43d3550b7a6',
            '_score' => 1.0,
            '_source' => {
              'title' => 'Test 2'
            }
          }
        ]
      }
    }
  end

  subject(:response) { described_class.new(test_model, mocked_response) }

  describe '.new' do
    it 'creates response with model and received data' do
      expect(response.model).to be test_model
      expect(response.raw_data).to be mocked_response
    end

    it 'loads data to model objects' do
      expect(response.first.class).to be test_model
    end
  end

  it 'has enumerable methods' do
    expect(subject.count).to eq 2
  end

  it 'silently ignores fields without mapping' do
    mocked_response['hits']['hits'][0]['_source'].merge!('foo' => 'Bar')
    expect { response.first }.not_to raise_error Mes::Elastic::Model::UnpermittedAttributeError
  end

  describe '#total_count' do
    it 'returns total_count' do
      expect(subject.total_count).to eq 10
    end
  end
end
