RSpec.shared_context 'multitype models' do
  let(:parent_model) do
    class Mes::ParentModel < described_class; end
    Mes::ParentModel.multitype
    Mes::ParentModel.config(url: test_elastic_url, index: test_index)
    Mes::ParentModel
  end

  let!(:first_sub_model) do
    class Mes::FirstSubModel < parent_model; end
    Mes::FirstSubModel.field(:title, :string)
    Mes::FirstSubModel
  end

  let!(:second_sub_model) do
    class Mes::SecondSubModel < parent_model; end
    Mes::SecondSubModel.field(:name, :string)
    Mes::SecondSubModel
  end

  after do
    undef_model :FirstSubModel
    undef_model :SecondSubModel
    undef_model :ParentModel
  end

  it 'doesn\'t allow to set fields for parent_model' do
    expect { parent_model.field :some_field, :string }
      .to raise_error described_class::SettingFieldsForModelWithoutTypeException
  end

  it 'delegates client and index to parent model' do
    expect(first_sub_model.client).to eq parent_model.client
    expect(first_sub_model.index).to eq parent_model.index
    expect(second_sub_model.client).to eq parent_model.client
    expect(second_sub_model.index).to eq parent_model.index
  end

  it 'creates instances of models by type' do
    expect(parent_model.build('first_sub_model', title: 'Some title').class)
      .to be first_sub_model
  end

  it 'creates instances of models by type, when passed to child model' do
    expect(first_sub_model.build('first_sub_model', title: 'Some title').class)
      .to be first_sub_model
  end

  it 'throws exception when try to use unknown type' do
    expect { parent_model.build('third_type', title: 'Some title') }
      .to raise_error described_class::UnknownTypeException
  end

  it 'throws exception when try to use wrong child model' do
    expect { parent_model.build('third_type', title: 'Some title') }
      .to raise_error described_class::UnknownTypeException
  end

  it 'throws exception when try to create instance of parent_model' do
    expect { parent_model.new(title: 'Some title') }
      .to raise_error described_class::IntatiatingModelWithoutType
  end

  describe '.find' do
    let(:id1) { '9084eddf-4a48-4e39-afbd-6f3e4e4dc7c5' }
    let(:id2) { '6ee40a2c-3980-450a-b075-d43d3550b7a6' }
    let(:title1) { 'Test 1' }
    let(:title2) { 'Test 2' }

    before do
      parent_model.purge_index!
      parent_model.client.index(
        index: test_model.index, type: first_sub_model.type, id: id1, body: { title: title1 }
      )
      parent_model.client.index(
        index: test_model.index, type: second_sub_model.type, id: id2, body: { name: title2 }
      )
      test_elastic_flush
    end

    it 'finds object by type' do
      expect(parent_model.find(id1).class).to be first_sub_model
      expect(parent_model.find(id1).title).to eq title1
      expect(parent_model.find(id2).class).to be second_sub_model
      expect(parent_model.find(id2).name).to eq title2
    end
  end
end
