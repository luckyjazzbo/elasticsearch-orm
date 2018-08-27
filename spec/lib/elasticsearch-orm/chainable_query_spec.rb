RSpec.shared_examples 'chainable query' do
  it 'returns same object' do
    expect(subject.class).to be described_class
  end

  it 'returns different query object' do
    expect(subject).not_to be query
  end

  it 'does not change initial query object' do
    expect { subject }.not_to change { query.body }
  end
end
