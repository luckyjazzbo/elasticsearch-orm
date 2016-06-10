require 'spec_helper'

describe Mes::Elastic do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  # Simple test for docker settings
  it 'has connection to EVA and MES ES' do
    expect(`curl -qs #{ENV['EVA_ELASTICSEARCH_URL']}`).to include '"status" : 200'
    expect(`curl -qs #{ENV['MES_ELASTICSEARCH_URL']}`).to include '"status" : 200'
  end

  it 'defines EVA and MES models' do
    expect { Eva::Elastic::Media }.not_to raise_exception
    expect { Eva::Elastic::Video }.not_to raise_exception
    expect { Mes::Elastic::Media }.not_to raise_exception
    expect { Mes::Elastic::Video }.not_to raise_exception
  end
end
