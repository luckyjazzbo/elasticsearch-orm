require 'spec_helper'

describe LteCore::Elasticsearch do
  it 'has a version number' do
    expect(LteCore::Elasticsearch::VERSION).not_to be nil
  end

  # Simple test for docker settings
  it 'has connection to EVA and MES ES' do
    expect(`curl -q #{ENV['EVA_ELASTICSEARCH_URL']}`).to include '"status" : 200'
    expect(`curl -q #{ENV['MES_ELASTICSEARCH_URL']}`).to include '"status" : 200'
  end

  it 'defines EVA and MES models' do
    expect { LteCore::Elasticsearch::EVA.new }.not_to raise_exception
    expect { LteCore::Elasticsearch::MES.new }.not_to raise_exception
  end
end
