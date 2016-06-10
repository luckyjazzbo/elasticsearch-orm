require 'spec_helper'

describe Mes::Elastic::Model do
  include_context 'with test indices'

  subject(:test_model) do
    class TestModel < described_class; end
    TestModel.set_index(test_index, url: test_elastic_url)
    TestModel
  end

  describe '.set_index' do
    let(:different_test_model) do
      class DifferentTestModel < described_class; end
      DifferentTestModel.set_index('other-test-index', url: ENV['MES_ELASTICSEARCH_URL'])
      DifferentTestModel
    end

    it 'creates client with received elastic configurations' do
      stubbed_client = double
      expect(::Elasticsearch::Client)
        .to receive(:new)
        .with(url: test_elastic_url)
        .and_return(stubbed_client)
      expect(subject.client).to eq stubbed_client
    end

    it "doesn't use same client for different subclasses" do
      expect(subject.client).not_to eq different_test_model.client
    end

    it 'saves index name to class' do
      expect(subject.index).to eq test_index
    end

    it "doesn't use same index for different subclasses" do
      expect(subject.index).not_to eq different_test_model.index
    end
  end

  describe '.index_exists?' do
    it 'returns false for not-existing index' do
      create_test_index
      expect(subject.index_exists?).to be_truthy
    end

    it 'returns false for not-existing index' do
      drop_test_index
      expect(subject.index_exists?).to be_falsey
    end
  end

  describe '.create_index' do
    before do
      drop_test_index
    end

    it 'creates index' do
      expect { subject.create_index }
        .to change { subject.index_exists? }
        .from(false).to(true)
    end

    it "doesn't fail if index exists" do
      subject.create_index
      expect { subject.create_index }.not_to raise_error
    end
  end

  describe '.drop_index!' do
    before do
      create_test_index
    end

    it 'drops index' do
      expect { subject.drop_index! }
        .to change { subject.index_exists? }
        .from(true).to(false)
    end

    it "doesn't fail if index doesn't exist" do
      subject.drop_index!
      expect { subject.drop_index! }.not_to raise_error
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
      }.to change {
        count_test_documents
      }.from(1).to(0)
    end

    it "doesn't fail if index doesn't exist" do
      subject.drop_index!
      expect { subject.purge_index! }.not_to raise_error
    end
  end
end
