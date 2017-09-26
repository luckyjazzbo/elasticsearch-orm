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

  describe '#multi_match' do
    it 'appends the query to the list' do
      subject.multi_match(query: 'foofoo', fields: ['foo', 'bar'])
      subject.multi_match(query: 'barbar', fields: ['foo', 'bar'])
      expect(subject.queries).to eq(
        [
          { multi_match: { query: 'foofoo', fields: ['foo', 'bar'] } },
          { multi_match: { query: 'barbar', fields: ['foo', 'bar'] } }
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
    context 'when only constants used in block' do
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

    context 'when variables used in block' do
      subject do
        Class.new do
          attr_reader :group_klass

          def initialize(group_klass)
            @group_klass = group_klass
          end

          def kabala
            group.any do |query|
              query.range(:foo, gt: one)
              query.range(:bar, lte: two)
            end

            group
          end

          def one
            1
          end

          def two
            2
          end

          def group
            @group ||= group_klass.new
          end
        end.new(described_class).kabala
      end

      it 'appends the query to the list' do
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

    describe '#all' do
      subject { described_class.new }

      before do
        subject.any do
          terms :a, :b

          all do
            terms :a, :c
            terms :b, :d
          end
        end
      end

      it 'adds bool groups to queries' do
        expect(subject.queries).to eq(
          [
            {
              bool: {
                should: [
                  {
                    term: { a: :b }
                  },
                  {
                    bool: {
                      must: [
                        { term: { a: :c } },
                        { term: { b: :d } },
                      ]
                    }
                  }
                ],
                minimum_should_match: 1
              }
            }
          ]
        )
      end
    end

    describe '#must_not' do
      subject { described_class.new }

      before do
        subject.any do
          terms :a, :b

          must_not do
            terms :a, :c
            terms :b, :d
          end
        end
      end

      it 'adds bool groups to queries' do
        expect(subject.queries).to eq(
          [
            {
              bool: {
                should: [
                  {
                    term: { a: :b }
                  },
                  {
                    bool: {
                      must_not: [
                        { term: { a: :c } },
                        { term: { b: :d } },
                      ]
                    }
                  }
                ],
                minimum_should_match: 1
              }
            }
          ]
        )
      end
    end

    describe '#bool' do
      subject { described_class.new }

      before do
        subject.any do
          terms :a, :b

          bool do
            must_not do
              terms :c, :d
            end
          end
        end
      end

      it 'adds must_not query to queries' do
        expect(subject.queries).to eq(
          [
            {
              bool: {
                should: [
                  {
                    term: { a: :b }
                  },
                  {
                    bool: {
                      must_not: [
                        { term: { c: :d } }
                      ]
                    }
                  }
                ],
                minimum_should_match: 1
              }
            }
          ]
        )
      end
    end
  end
end
