require 'spec_helper'

describe 'mes/elastic/rspec helper' do
  it 'is loaded without errors' do
    expect {
      require 'mes/elastic/rspec'
    }.not_to raise_error
  end
end
