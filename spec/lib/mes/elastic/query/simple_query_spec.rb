require 'spec_helper'

RSpec.describe Mes::Elastic::SimpleQuery do
  include_context 'with test indices'

  subject(:query) { described_class.new(test_model) }

  describe '#all' do
    subject { query.all }
    it_behaves_like 'chainable query'

    it 'appends matchAll expression to query' do
      expect(subject.body).to eq(query: { filtered: { query: { match_all: {} } } })
    end
  end

  describe '#match' do
    subject { query.match _id: '123' }
    it_behaves_like 'chainable query'

    it 'appends match expression to query' do
      expect(subject.body).to eq(query: { filtered: { query: { match: { _id: '123' } } } })
    end
  end

  describe '#ids' do
    context 'when a value' do
      subject { query.ids '123' }
      it_behaves_like 'chainable query'

      it 'appends match expression to query' do
        expect(subject.body).to eq(query: { filtered: { query: { ids: { values: ['123'] } } } })
      end
    end

    context 'when an array' do
      subject { query.ids ['123', '456'] }
      it_behaves_like 'chainable query'

      it 'appends match expression to query' do
        expect(subject.body).to eq(query: { filtered: { query: { ids: { values: ['123', '456'] } } } })
      end
    end
  end

  describe '#terms' do
    context 'when a value' do
      subject { query.terms :_id, '123' }
      it_behaves_like 'chainable query'

      it 'appends match expression to query' do
        expect(subject.body).to eq(query: { filtered: { filter: { term: { _id: '123' } } } })
      end
    end

    context 'when an array' do
      subject { query.terms :_id, ['123'] }

      it 'appends match expression to query' do
        expect(subject.body).to eq(query: { filtered: { filter: { terms: { _id: ['123'] } } } })
      end
    end

    context 'when nil' do
      subject { query.terms :_id, nil }

      it 'appends match expression to query' do
        expect(subject.body).to eq(query: { filtered: { filter: { missing: { field: :_id } } } })
      end
    end
  end

  describe '#must' do
    subject do
      query
        .match(:_id, '123')
        .order('_id desc')
        .limit(1)
        .must { range(:start_date, 321) }
    end

    it 'transforms to BoolQuery' do
      expect(subject).to be_a(Mes::Elastic::BoolQuery)
    end

    it 'transforms original query' do
      expect(subject.body).to eq(
        query: {
          bool: {
            must: [
              { query: { filtered: { query: { match: { _id: '123' } } } } },
              { range: { start_date: 321 } }
            ]
          }
        },
        sort: [{ '_id' => { order: 'desc' } }],
        size: 1
      )
    end
  end

  describe '#must_not' do
    subject do
      query
        .match(:_id, '123')
        .order('_id desc')
        .limit(1)
        .must_not { range(:start_date, 321) }
    end

    it 'transforms to BoolQuery' do
      expect(subject).to be_a(Mes::Elastic::BoolQuery)
    end

    it 'transforms original query' do
      expect(subject.body).to eq(
        query: {
          bool: {
            must: [
              { query: { filtered: { query: { match: { _id: '123' } } } } }
            ],
            must_not: [
              { range: { start_date: 321 } }
            ]
          }
        },
        sort: [{ '_id' => { order: 'desc' } }],
        size: 1
      )
    end
  end
end
