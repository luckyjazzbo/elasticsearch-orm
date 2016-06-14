require 'spec_helper'

RSpec.shared_examples 'chainable query' do
  it 'returns same object' do
    expect(subject.class).to be described_class
  end

  it 'returns different query object' do
    expect(subject).not_to be query
  end

  it 'doesn\'t change initial query object' do
    expect { subject }.not_to change { query.body }
  end
end

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
    subject { query.match _id: '123' }
    it_behaves_like 'chainable query'

    it 'appends match expression to query' do
      expect(subject.body).to eq(body_with_id_query)
    end
  end

  describe '#all' do
    subject { query.all }
    it_behaves_like 'chainable query'

    it 'appends matchAll expression to query' do
      expect(subject.body).to eq({ query: { matchAll: {} } })
    end
  end

  describe '#limit' do
    subject { query.limit(12) }
    it_behaves_like 'chainable query'

    it 'appends matchAll expression to query' do
      expect(subject.body).to eq({ query: {}, size: 12 })
    end
  end

  describe '#execute' do
    subject { query.match(_id: '123').execute }

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

      expect(subject).to eq elastic_response
    end
  end
end
