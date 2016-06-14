require 'spec_helper'

describe Mes::Elastic::Query do
  include_context 'with test indices'

  subject(:query) { described_class.new(test_model) }
  let(:body_with_id_query) { { query: { match: { _id: '123' } } } }

  describe '.new' do
    it 'creates empty query for specific model class' do
      expect(query.model).to be test_model
    end
  end

  describe '#match' do
    it 'appends match expresion to query' do
      expect { query.match _id: '123' }
        .to change { query.body.to_s }
        .from({ query: { } }.to_s)
        .to(body_with_id_query.to_s)
    end

    it 'returns self' do
      expect(query.match(_id: '123')).to be query
    end
  end

  describe '#all' do
    it 'appends matchAll expresion to query' do
      expect { query.all }
        .to change { query.body.to_s }
        .from({ query: { } }.to_s)
        .to({ query: { matchAll: {} } }.to_s)
    end

    it 'returns self' do
      expect(query.all).to be query
    end
  end

  describe '#all' do
    it 'appends matchAll expresion to query' do
      expect { query.limit(12) }
        .to change { query.body.to_s }
        .from({ query: { } }.to_s)
        .to({ query: { }, size: 12 }.to_s)
    end

    it 'returns self' do
      expect(query.limit(12)).to be query
    end
  end

  describe '#execute' do
    before do
      query.match(_id: '123')
    end

    let(:mocked_response) { double }
    let(:elastic_response) { double }

    it 'runs the correct query via model\'s client and covers it with Response class' do
      expect(test_model.client)
        .to receive(:search)
        .with(index: test_model.index, type: test_model.type, body: body_with_id_query)
        .and_return mocked_response
      expect(Mes::Elastic::Response)
        .to receive(:new)
        .with(test_model, mocked_response)
        .and_return(elastic_response)
      expect(query.execute).to eq elastic_response
    end
  end
end
