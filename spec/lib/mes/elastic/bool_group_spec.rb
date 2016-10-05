require 'spec_helper'

describe Mes::Elastic::BoolGroup do
  describe '#queries' do
    it 'empty by default' do
      expect(subject.queries).to eq([])
    end
  end

  describe '#query' do
    let(:query) { double }
    let(:query2) { double }

    it 'appends the whole query to the list' do
      subject.query(query)
      subject.query(query2)
      expect(subject.queries).to eq([query, query2])
    end
  end

  describe '#range' do
    it 'appends the whole query to the list' do
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
end
