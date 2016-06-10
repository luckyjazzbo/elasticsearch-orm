require 'spec_helper'

describe Mes::Elastic::Model do
  let(:elastic_connection_config) { { url: ENV['EVA_ELASTICSEARCH_URL'] } }
  let(:elastic_config) { elastic_connection_config.merge(index: 'test-index') }
  let(:mes_elastic_config) { { url: ENV['MES_ELASTICSEARCH_URL'], index: 'other-test-index' } }

  subject(:test_model) do
    class TestModel < described_class; end
    TestModel.connect(elastic_config)
    TestModel
  end

  let(:client) { subject.client }

  describe '.connect' do
    let(:different_test_model) do
      class DifferentTestModel < described_class; end
      DifferentTestModel.connect(mes_elastic_config)
      DifferentTestModel
    end

    it 'creates client with received elastic configurations' do
      stubbed_client = double
      expect(::Elasticsearch::Client)
        .to receive(:new)
        .with(elastic_connection_config)
        .and_return(stubbed_client)
      expect(subject.client).to eq stubbed_client
    end

    it 'doesn\'t use same client for different subclasses' do
      expect(subject.client).not_to eq different_test_model.client
    end

    it 'saves index name to class' do
      expect(subject.index).to eq elastic_config[:index]
    end

    it 'doesn\'t use same index for different subclasses' do
      expect(subject.index).not_to eq different_test_model.index
    end
  end

  describe '.index_exists?' do
    it 'returns false for not-existing index' do
      unless client.indices.exists? index: subject.index
        client.indices.create index: subject.index
      end
      expect(subject.index_exists?).to be_truthy
    end

    it 'returns false for not-existing index' do
      if client.indices.exists? index: subject.index
        client.indices.delete index: subject.index
      end
      expect(subject.index_exists?).to be_falsey
    end
  end

  describe '.create_index' do
    before do
      if client.indices.exists? index: subject.index
        client.indices.delete index: subject.index
      end
    end

    it 'creates index' do
      expect { subject.create_index }
        .to change { subject.index_exists? }
        .from(false).to(true)
    end

    it "doesn't fail if index exists" do
      subject.create_index
      expect { subject.create_index }
        .not_to raise_exception ::Elasticsearch::Transport::Transport::Errors::BadRequest
    end
  end
end
