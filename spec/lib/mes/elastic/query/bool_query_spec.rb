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

      it 'excepts options' do
        query_1_ = query_1
        query_2_ = query_2

        query = subject.send(filter_type, min_match: 1) do
          raw(query_1_)
          raw(query_2_)
        end

        expect(query.body).to eq(query: { bool: { filter_type => [query_1, query_2], minimum_should_match: 1 } })
      end

      it 'does not rewrite existing filters' do
        query_1_ = query_1
        query_2_ = query_2

        query = subject
                .send(filter_type) { raw(query_1_) }
                .send(filter_type) { raw(query_2_) }

        expect(query.body).to eq(query: { bool: { filter_type => [query_1, query_2] } })
      end

      it 'have access to global variables' do
        query = subject
                .send(filter_type) { |q| q.raw(query_1) }
                .send(filter_type) { |q| q.raw(query_2) }

        expect(query.body).to eq(query: { bool: { filter_type => [query_1, query_2] } })
      end
    end
  end

  context '#must' do
    before do
      test_model.field :title, :text
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
          raw(term: { title: 'foo' })
          range(:start_date, gt: 15)
        end
    end

    it 'returns correct object set' do
      expect(subject.map(&:id)).to match_array ['d3']
    end
  end

  context '#filter' do
    before do
      test_model.field :title, :text
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

  describe '#find' do
    before do
      test_model.field :taxonomy, :text
      test_model.purge_index!

      index_test_document(id: 'd1', body: { taxonomy: 't1' })
      index_test_document(id: 'd2', body: { taxonomy: 't1' })
      index_test_document(id: 'd3', body: { taxonomy: 't2' })
      test_elastic_flush
    end

    context 'in query scope' do
      subject do
        test_model
          .terms('taxonomy', 't1')
          .find('d2')
      end

      it 'returns correct object' do
        expect(subject.id).to eq('d2')
      end
    end

    context 'not in query scope' do
      subject do
        test_model
          .terms('taxonomy', 't2')
          .find('d2')
      end

      it 'raises error' do
        expect { subject }.to raise_error(Mes::Elastic::Model::RecordNotFoundError)
      end
    end
  end
end
