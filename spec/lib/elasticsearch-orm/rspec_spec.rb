require 'spec_helper'

RSpec.describe 'elasticsearch-orm/rspec helper' do
  it 'is loaded without errors' do
    expect {
      require 'elasticsearch-orm/rspec'
    }.not_to raise_error
  end
end
