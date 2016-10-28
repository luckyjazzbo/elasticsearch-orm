require 'spec_helper'

RSpec.describe Mes::Elastic::BoolQuery do
  include_context 'with test indices'

  subject(:bool_query) { described_class.new(test_model) }

  [:must, :must_not, :should, :filter].each do |filter_type|
    describe "##{filter_type}" do
      let(:query_1) { { term: { foo: 'bar' } } }
      let(:query_2) { { term: { foo2: 'bar2' } } }

      it 'appends expressions to must' do
        query_1_ = query_1
        query_2_ = query_2

        query = subject.send(filter_type) do
          raw(query_1_)
          raw(query_2_)
        end

        expect(query.body).to eq(query: { bool: { filter_type => [query_1, query_2] } })
      end

      it 'does not rewrite existing filters' do
        query_1_ = query_1
        query_2_ = query_2

        query = subject
                .send(filter_type) { raw(query_1_) }
                .send(filter_type) { raw(query_2_) }

        expect(query.body).to eq(query: { bool: { filter_type => [query_1, query_2] } })
      end
    end
  end

  context '#must' do
    before do
      test_model.field :title, :string
      test_model.field :start_date, :double
      test_model.purge_index!

      index_test_document(id: 'd1', body: { title: 'foo', start_date: 10 })
      index_test_document(id: 'd2', body: { title: 'bar', start_date: 20 })
      index_test_document(id: 'd3', body: { title: 'foo', start_date: 20 })
      test_elastic_flush
    end

    subject do
      described_class
        .new(test_model)
        .must do
          raw(query: { term: { title: 'foo' } })
          range(:start_date, gt: 15)
        end
    end

    it 'returns correct object set' do
      expect(subject.map(&:id)).to match_array ['d3']
    end
  end

  context '#filter' do
    before do
      test_model.field :title, :string
      test_model.field :start_date, :double
      test_model.purge_index!

      index_test_document(id: 'd1', body: { title: 'foo', start_date: 10 })
      index_test_document(id: 'd2', body: { title: 'bar', start_date: 20 })
      index_test_document(id: 'd3', body: { title: 'foo', start_date: 20 })
      test_elastic_flush
    end

    subject do
      described_class
        .new(test_model)
        .filter do
          terms(:title, 'foo')
          range(:start_date, gt: 15)
        end
    end

    it 'returns correct object set' do
      expect(subject.map(&:id)).to match_array ['d3']
    end
  end
end
