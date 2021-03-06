require 'spec_helper'

RSpec.describe 'Elastic API methods' do
  include_context 'with test indices'

  let(:subject) { test_model }

  describe '.config' do
    let(:different_test_model) do
      class DifferentTestModel < ElasticsearchOrm::Model; end
      DifferentTestModel.config(
        url: ENV['ELASTICSEARCH_URL'],
        index: 'other-test-index',
        index_settings: index_settings_for_one_shard
      )
      DifferentTestModel
    end

    after do
      undef_model :DifferentTestModel
    end

    it 'creates client with received elastic configurations' do
      stubbed_client = double
      expect(::Elasticsearch::Client)
        .to receive(:new)
        .with(url: test_elastic_url)
        .and_return(stubbed_client)
      expect(subject.client).to eq stubbed_client
    end

    it 'does not use same client for different subclasses' do
      expect(subject.client).not_to eq different_test_model.client
    end

    it 'saves index name to class' do
      expect(subject.index).to eq test_index
    end

    it 'takes type from class name if not specified' do
      expect(subject.type).to eq test_type
    end

    it "doesn't use same index for different subclasses" do
      expect(subject.index).not_to eq different_test_model.index
    end
  end

  describe '.type_exists?' do
    it 'returns false for not-existing index' do
      create_test_index
      test_elastic_flush
      expect(subject.type_exists?).to be_truthy
    end

    it 'returns false for not-existing index' do
      drop_test_index
      test_elastic_flush
      expect(subject.type_exists?).to be_falsey
    end
  end

  describe '.index_exists?' do
    it 'returns false for not-existing index' do
      create_test_index
      test_elastic_flush
      expect(subject.index_exists?).to be_truthy
    end

    it 'returns false for not-existing index' do
      drop_test_index
      test_elastic_flush
      expect(subject.index_exists?).to be_falsey
    end
  end

  describe '.create_index!' do
    before do
      drop_test_index
    end

    it 'creates index' do
      expect { subject.create_index! }
        .to change { subject.index_exists? }
        .from(false).to(true)
    end

    it "doesn't fail if index exists" do
      subject.create_index!
      expect { subject.create_index! }.not_to raise_error
    end
  end

  describe '.create_index' do
    let(:new_test_index) { 'lte-awake' }

    before do
      drop_test_index
      drop_index(new_test_index)
    end

    it 'creates index with provided value' do
      expect { subject.create_index(index_name: new_test_index) }
        .to change { subject.client.indices.exists?(index: new_test_index) }
        .from(false).to(true)
    end

    it 'create default alias' do
      expect { subject.create_index(index_name: new_test_index) }
        .to change { subject.client.indices.exists_alias(name: test_index) }
        .from(false).to(true)
    end
  end

  describe '.create_alias' do
    let(:new_test_index) { 'southtown' }
    before do
      drop_index(new_test_index)
      create_index(new_test_index)

      drop_test_index
      test_elastic_flush
    end

    it 'create provided alias' do
      expect { subject.create_alias(new_test_index) }
        .to change { subject.client.indices.exists_alias(name: test_index) }
        .from(false).to(true)
    end
  end

  describe '.delete_alias' do
    let(:new_test_index) { 'golovach' }
    before do
      drop_test_index
      drop_index(new_test_index)

      create_index(new_test_index)
      create_alias(test_index, new_test_index)
      test_elastic_flush
    end

    it 'create provided alias' do
      expect { subject.delete_alias(new_test_index) }
        .to change { subject.client.indices.exists_alias(name: test_index) }
        .from(true).to(false)
    end
  end

  describe '.switch_alias' do
    let(:old_test_index) { 'lte-meet' }
    let(:new_test_index) { 'lte-me' }

    before do
      drop_test_index
      drop_alias(test_index, new_test_index)
      drop_alias(test_index, old_test_index)
      drop_index(new_test_index)
      drop_index(old_test_index)

      create_index(new_test_index)
      create_index(old_test_index)
      create_alias(test_index, old_test_index)
      test_elastic_flush
    end

    it 'create delete alias from old index' do
      expect { subject.switch_alias(new_test_index) }
        .to change { subject.client.indices.get_alias(name: test_index, index: old_test_index).size }
        .from(1).to(0)
    end

    it 'create create alias for new index' do
      expect { subject.switch_alias(new_test_index) }
        .to change { subject.client.indices.get_alias(name: test_index, index: new_test_index).size }
        .from(0).to(1)
    end
  end

  describe '.delete_index!' do
    before do
      create_test_index
      test_elastic_flush
    end

    it 'drops index' do
      expect { subject.delete_index! }
        .to change { subject.index_exists? }
        .from(true).to(false)
    end

    it "doesn't fail if index doesn't exist" do
      subject.delete_index!
      test_elastic_flush
      expect { subject.delete_index! }.not_to raise_error
    end
  end

  describe '.purge_index!' do
    before do
      purge_test_index
      index_test_document
      test_elastic_flush
    end

    it 'empties index' do
      expect {
        subject.purge_index!
        test_elastic_flush
      }.to change { count_test_documents }
        .from(1).to(0)
    end

    it 'does not fail if index does not exist' do
      subject.delete_index!
      expect { subject.purge_index! }.not_to raise_error
    end
  end

  describe '.create_mapping' do
    it 'creates mappings' do
      subject.field :sample_field, type: :keyword
      subject.create_mapping
      expect(recursive_stringify_mapping(subject.mapping[:properties])).to eq(test_mapping['properties'])
    end
  end

  describe '.delete_all' do
    context 'when model with type' do
      before do
        purge_test_index
        index_test_document
        test_elastic_flush
      end

      it 'deletes all documents' do
        subject.delete_all
        test_elastic_flush
        expect(count_test_documents).to eq(0)
      end
    end

    context 'when multitype model' do
      let(:subject) { test_multitype_model }

      before do
        purge_test_index
        index_test_document
        test_elastic_flush
      end

      it 'deletes all documents' do
        subject.delete_all
        test_elastic_flush
        expect(count_test_documents).to eq(0)
      end
    end
  end
end
