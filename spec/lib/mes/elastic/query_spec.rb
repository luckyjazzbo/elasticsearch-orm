require 'spec_helper'

RSpec.describe Mes::Elastic::Query do
  include_context 'with test indices'

  let(:default_query_body) { { query: {} } }
  subject(:query) { described_class.new(test_model) }
  let(:body_with_id_query) { { query: { match: { _id: '123' } } } }

  describe '.new' do
    it 'creates empty query for specific model class' do
      expect(query.model).to be test_model
    end

    it 'sets default body' do
      expect(query.body).to eq default_query_body
    end

    context 'with custom body' do
      let(:query_body) { { query: { custom: :query } } }
      subject(:query) { described_class.new(test_model, body: query_body) }

      it 'sets default body' do
        expect(query.body).to eq(query_body)
      end
    end
  end

  describe '#each' do
    context 'with one response' do
      let(:elastic_response) { double }
      before do
        expect(query).to receive(:execute).and_return elastic_response
        expect(elastic_response)
          .to receive(:each)
          .and_yield(1).and_yield(2).and_yield(3)
      end

      it 'runs query and iterates on response' do
        expect { |block|
          query.each(&block)
        }.to yield_control.exactly(3).times
      end
    end
  end

  describe '#size' do
    let(:elastic_response) { double }
    before do
      expect(query).to receive(:execute).and_return elastic_response
    end

    it 'runs query and returns count' do
      expect(elastic_response).to receive(:count).and_return 2
      expect(query.size).to eq 2
    end
  end

  describe '#total_count' do
    let(:elastic_response) { double }
    before do
      expect(query).to receive(:execute).and_return elastic_response
    end

    it 'runs query and returns total_count' do
      expect(elastic_response).to receive(:total_count).and_return 78
      expect(query.total_count).to eq 78
    end
  end

  describe '#limit' do
    subject { query.limit(12) }
    it_behaves_like 'chainable query'

    it 'appends limit expression to query' do
      expect(subject.body).to eq({ query: {}, size: 12 })
    end
  end

  describe '#offset' do
    subject { query.offset(12) }
    it_behaves_like 'chainable query'

    it 'appends from expression to query' do
      expect(subject.body).to eq({ query: {}, from: 12 })
    end
  end

  describe '#order' do
    context 'when ordering by single field in asc order by default' do
      subject { query.order('val') }
      it_behaves_like 'chainable query'

      it 'appends matchAll expression to query' do
        expect(subject.body).to eq({ query: {}, sort: [{ 'val' => { order: 'asc' } }] })
      end
    end

    context 'when ordering by single field in desc' do
      subject { query.order('val desc') }
      it_behaves_like 'chainable query'

      it 'appends matchAll expression to query' do
        expect(subject.body).to eq({ query: {}, sort: [{ 'val' => { order: 'desc' } }] })
      end
    end

    context 'when ordering by multiple fields' do
      subject { query.order('val desc, val2 asc') }
      it_behaves_like 'chainable query'

      it 'appends matchAll expression to query' do
        expect(subject.body).to eq({ query: {}, sort: [
          { 'val' => { order: 'desc' } },
          { 'val2' => { order: 'asc' } }
        ] })
      end
    end
  end

  describe '#fields' do
    subject { query.select(['_id', 'title']) }

    it 'appends fields expression to body' do
      expect(subject.body).to eq(
        query: {},
        _source: ['_id', 'title']
      )
    end

    context 'with existing body' do
      let(:query_body) { { query: { hello: :world }, _source: ['_id', 'other_field'] } }
      let(:query) { described_class.new(test_model, body: query_body) }
      subject { query.select(['_id', 'title']) }

      it 'appends fields expression to existing ones' do
        expect(subject.body).to eq(
          query: { hello: :world },
          _source: ['_id', 'title']
        )
      end
    end
  end

  describe '#execute' do
    subject { query.tap { |q| q.body = body_with_id_query }.execute }

    let(:mocked_response) { double }
    let(:elastic_response) { double }

    it "runs the correct query via model's client and covers it with Response class" do
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
