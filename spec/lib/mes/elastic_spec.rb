require 'spec_helper'

describe Mes::Elastic do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  # Simple test for docker settings
  it 'has connection to ES' do
    expect(`curl -I #{ENV['ELASTICSEARCH_URL']}`).to include '200 OK'
  end

  it 'defines EVA, MES and ContentApi models' do
    expect { Eva::Elastic::Resource }.not_to raise_exception
    expect { Mes::Elastic::Resource }.not_to raise_exception
    expect { ContentApi::Elastic::Resource }.not_to raise_exception
  end
end
