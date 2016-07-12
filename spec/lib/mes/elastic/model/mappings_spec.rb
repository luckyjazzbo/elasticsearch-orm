require 'spec_helper'

RSpec.describe 'Mappings' do
  include_context 'with test indices'

  describe '.field' do
    let(:subject) { test_model }

    it 'defines id field by default' do
      expect(test_model.field?(:id)).to be_truthy
    end

    it 'defines a field in mapping' do
      expect { test_model.field :test_field, :string }
        .to change { test_model.field? :test_field }
        .from(false).to(true)
    end

    it 'defines readers for fields' do
      test_model.field :test_field, :string
      obj = test_model.new test_field: 'value'
      expect(obj.test_field).to eq 'value'
    end

    it 'defines writers for fields' do
      test_model.field :test_field, :string
      obj = test_model.new test_field: 'value'
      expect { obj.test_field = 'new value' }
        .to change { obj.test_field }
        .from('value').to('new value')
    end

    it 'fails to create field with reserved names' do
      expect { test_model.field :send, :string }
        .to raise_error Mes::Elastic::Model::UnpermittedFieldNameError
    end
  end

  describe '.array' do
    let(:subject) { test_model }

    it 'defines a field in mapping' do
      expect { test_model.array :test_field, :string }
        .to change { test_model.field? :test_field }
        .from(false).to(true)
    end

    it 'defines readers for fields' do
      test_model.array :test_field, :string
      obj = test_model.new test_field: ['value']
      expect(obj.test_field).to eq ['value']
    end

    it 'defines writers for fields' do
      test_model.array :test_field, :string
      obj = test_model.new test_field: ['value']
      expect { obj.test_field = ['new value'] }
        .to change { obj.test_field }
        .from(['value']).to(['new value'])
    end
  end

  describe '.object' do
    let(:instance) { subject.new }

    context 'when shallow' do
      subject do
        class Mes::ShallowObjectTestModel < Mes::Elastic::Model
          object :object_field do
            field :object_subfield, type: :integer
          end
        end
        config_test_model_class Mes::ShallowObjectTestModel
      end

      it 'builds correct mapping' do
        expect(subject.mapping[:object_field]).to eq(
          properties: {
            object_subfield: { type: :integer }
          }
        )
      end

      it 'defines an accessor' do
        expect(instance).to respond_to(:object_field)
      end

      it 'allows to access subfields' do
        expect(instance.object_field).to respond_to(:object_subfield)
      end

      it 'allows to set subfields' do
        expect(instance.object_field).to respond_to(:object_subfield=)
      end

      it 'reads the same value after setting of subfields' do
        instance.object_field.object_subfield = 1
        expect(instance.object_field.object_subfield).to eq(1)
      end
    end

    context 'when nested' do
      subject do
        class Mes::NestedObjectTestModel < Mes::Elastic::Model
          object :object_field do
            object :subobject_field do
              field :subobject_subfield, type: :integer
            end
          end
        end
        config_test_model_class Mes::NestedObjectTestModel
      end

      it 'builds correct mapping' do
        expect(subject.mapping[:object_field]).to eq(
          properties: {
            subobject_field: {
              properties: {
                subobject_subfield: { type: :integer }
              }
            }
          }
        )
      end

      it 'allows to access subsubfields' do
        expect(instance.object_field.subobject_field).to respond_to(:subobject_subfield)
      end

      it 'allows to set subsubfields' do
        expect(instance.object_field.subobject_field).to respond_to(:subobject_subfield=)
      end

      it 'reads the same value after setting of subsubfields' do
        instance.object_field.subobject_field.subobject_subfield = 1
        expect(instance.object_field.subobject_field.subobject_subfield).to eq(1)
      end
    end
  end

  describe '.new' do
    let(:subject) { test_model }

    before do
      test_model.field :correct_field, :string
    end

    it 'allows to set id' do
      expect(test_model.new(id: 'some id').id).to eq 'some id'
    end

    it 'allows fields from mapping on creating new instance' do
      expect { test_model.new(correct_field: 'value') }
        .not_to raise_error # Mes::Elastic::Model::UnpermittedAttributeError
    end

    it 'allows fields from mapping on creating new instance, when pass them as strings' do
      expect { test_model.new('correct_field' => 'value') }
        .not_to raise_error # Mes::Elastic::Model::UnpermittedAttributeError
    end

    context 'with permitting only defined attributes' do
      it 'rejects params which do not appear in mapping on creating new instance' do
        expect { test_model.new(wrong_field: 'value') }
          .to raise_error Mes::Elastic::Model::UnpermittedAttributeError
      end

      it 'allows access to fields via methods' do
        t = test_model.new('correct_field' => 'value')
        expect(t.correct_field).to eq 'value'
      end
    end
  end
end
