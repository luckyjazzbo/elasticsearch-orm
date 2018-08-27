require 'spec_helper'

RSpec.describe ElasticsearchOrm::Model do
  include_context 'with test indices'
  let(:subject) { test_model }

  context 'complex nested query with original query' do
    subject do
      test_model
        .raw(
          'query' => { 'terms' => { '_id' => ['1', '2', '3'] } },
          'sort' => [{ 'modified_at' => { 'order' => 'desc' } }]
        )
        .must do
          multi_match(query: 'foo', fields: ['bar'])
          any do
            range(:date, gt: 123)
            terms(:date, nil)
          end
          any do
            range(:'license.date', gt: 123)
            terms(:'license.date', nil)
          end
        end
        .limit(1)
    end

    it 'formats correct query' do
      expect(subject.body).to eq(
        query: {
          bool: {
            must: [
              { 'terms' => { '_id' => ['1', '2', '3'] } },
              { multi_match: { query: 'foo', fields: ['bar'] } },
              { bool: { should: [{ range: { date: { gt: 123 } } }, { bool: { must_not: [{ exists: { field: :date } }] } }], minimum_should_match: 1 } },
              { bool: { should: [{ range: { :'license.date' => { gt: 123 } } }, { bool: { must_not: [{ exists: { field: :'license.date' } }] } }], minimum_should_match: 1 } }
            ]
          }
        },
        sort: [{ 'modified_at' => { 'order' => 'desc' } }],
        size: 1
      )
    end
  end
end
