require 'spec_helper'

describe ElasticsearchOrm do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  # Simple test for docker settings
  it 'has connection to ES' do
    expect(`curl -I #{ENV['ELASTICSEARCH_URL']}`).to include '200 OK'
  end
end
