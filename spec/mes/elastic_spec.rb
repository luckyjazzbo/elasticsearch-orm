require 'spec_helper'

describe Mes::Elastic do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  # Simple test for docker settings
  it 'has connection to EVA and MES ES' do
  expect(`curl -q #{ENV['EVA_ELASTICSEARCH_URL']}`).to include '"status" : 200'
    expect(`curl -q #{ENV['MES_ELASTICSEARCH_URL']}`).to include '"status" : 200'
  end

  it 'defines EVA and MES models' do
    expect { Mes::EvaIndex.new }.not_to raise_exception
    expect { Mes::MesIndex.new }.not_to raise_exception
  end
end
