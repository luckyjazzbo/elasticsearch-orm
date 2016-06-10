require 'spec_helper'

describe Mes::Elastic do
  it 'has a version number' do
    expect(Mes::Elastic::VERSION).not_to be nil
  end

  # Simple test for docker settings
  it 'has connection to EVA and MES ES' do
    expect(`curl -q #{ENV['EVA_ELASTICSEARCH_URL']}`).to include '"status" : 200'
    expect(`curl -q #{ENV['MES_ELASTICSEARCH_URL']}`).to include '"status" : 200'
  end

  it 'defines EVA and MES models' do
    expect { Mes::Elastic::EVA.new }.not_to raise_exception
    expect { Mes::Elastic::MES.new }.not_to raise_exception
  end
end
