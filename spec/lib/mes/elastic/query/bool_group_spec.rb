require 'spec_helper'

RSpec.describe Mes::Elastic::BoolGroup do
  describe '#queries' do
    it 'empty by default' do
      expect(subject.queries).to eq([])
    end
  end

  describe '#raw' do
    let(:query) { double }
    let(:query2) { double }

    it 'appends the query to the list' do
      subject.raw(query)
      subject.raw(query2)
      expect(subject.queries).to eq([query, query2])
    end
  end

  describe '#match' do
    it 'appends the query to the list' do
      subject.match(:foo, '1')
      subject.match(:bar, '2')
      expect(subject.queries).to eq(
        [
          { match: { foo: '1' } },
          { match: { bar: '2' } }
        ]
      )
    end
  end

  describe '#terms' do
    it 'appends the query to the list' do
      subject.terms(:foo, 1)
      subject.terms(:bar, [2])
      expect(subject.queries).to eq(
        [
          { term: { foo: 1 } },
          { terms: { bar: [2] } }
        ]
      )
    end
  end

  describe '#range' do
    it 'appends the query to the list' do
      subject.range(:foo, gt: 1)
      subject.range(:bar, lte: 2)
      expect(subject.queries).to eq(
        [
          { range: { foo: { gt: 1 } } },
          { range: { bar: { lte: 2 } } }
        ]
      )
    end
  end

  describe '#any' do
    it 'appends the query to the list' do
      subject.any do
        range(:foo, gt: 1)
        range(:bar, lte: 2)
      end
      expect(subject.queries).to eq(
        [
          {
            bool: {
              should: [
                { range: { foo: { gt: 1 } } },
                { range: { bar: { lte: 2 } } }
              ],
              minimum_should_match: 1
            }
          }
        ]
      )
    end
  end
end
