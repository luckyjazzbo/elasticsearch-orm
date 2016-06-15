require 'spec_helper'

RSpec.shared_context 'lookup methods' do
  let(:id1) { '9084eddf-4a48-4e39-afbd-6f3e4e4dc7c5' }
  let(:id2) { '6ee40a2c-3980-450a-b075-d43d3550b7a6' }
  let(:title1) { 'Test 1' }
  let(:title2) { 'Test 2' }

  context 'with 2 documents in index' do
    before do
      test_model.field :title, :string
      test_model.purge_index!
      test_model.client.index(
        index: test_model.index, type: test_model.type, id: id1, body: { title: title1 }
      )
      test_model.client.index(
        index: test_model.index, type: 'other-type', id: id2, body: { title: title2 }
      )
      test_elastic_flush
    end

    describe '.find' do
      it 'creates instance for found documents' do
        expect(test_model.find(id1).class).to be test_model
      end

      it 'loads attributes for found document' do
        expect(test_model.find(id1).id).to eq id1
        expect(test_model.find(id1).title).to eq title1
      end

      it 'raises NotFound exception for not-existing ids' do
        expect { test_model.find 'not-existing-id' }
          .to raise_error described_class::RecordNotFoundException
      end

      it 'raises NotFound exception for ids, which belong to different type' do
        expect { test_model.find id2 }
          .to raise_error described_class::RecordNotFoundException
      end
    end

    describe '.count' do
      let(:multitype_model) do
        class Mes::MultitypeModel < described_class
          multitype
        end
        Mes::MultitypeModel.config(url: test_elastic_url, index: test_index)
        Mes::MultitypeModel
      end

      after do
        undef_model :MultitypeModel
      end

      it 'counts records in simple model' do
        expect(test_model.count).to eq 1
      end

      it 'counts records in multitype model' do
        expect(multitype_model.count).to eq 2
      end
    end
  end

  describe '.all' do
    before do
      test_model.field :title, :string
      test_model.purge_index!
      test_model.client.index(
        index: test_model.index, type: test_model.type, id: id1, body: { title: title1 }
      )
      test_model.client.index(
        index: test_model.index, type: test_model.type, id: id2, body: { title: title2 }
      )
      test_elastic_flush
    end

    it 'iterates among all documents' do
      expect { |block|
        test_model.all.each(&block)
      }.to yield_control.twice
    end
  end
end
