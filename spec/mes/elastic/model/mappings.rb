require 'spec_helper'

RSpec.shared_context 'mappings' do
  describe '.field' do
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
        .to raise_error described_class::UnpermittedFieldNameException
    end
  end

  describe '.new' do
    before do
      test_model.field :correct_field, :string
    end

    it 'allows to set id' do
      expect(test_model.new(id: 'some id').id).to eq 'some id'
    end

    it 'allows fields from mapping on creating new instance' do
      expect { test_model.new(correct_field: 'value') }
        .not_to raise_error # described_class::UnpermittedAttributeException
    end

    it 'allows fields from mapping on creating new instance, when pass them as strings' do
      expect { test_model.new('correct_field' => 'value') }
        .not_to raise_error # described_class::UnpermittedAttributeException
    end

    context 'with auto-defining attributes via assign' do
      it 'defines new field when it appears in assign' do
        expect { test_model.new(wrong_field: 'value') }
          .to change { test_model.mapping }
          .from(id: :string, correct_field: :string)
          .to(id: :string, correct_field: :string, wrong_field: :string)
      end

      it 'defines new field when it appears in assign as string' do
        expect { test_model.new('wrong_field' => 'value') }
          .to change { test_model.mapping }
          .from(id: :string, correct_field: :string)
          .to(id: :string, correct_field: :string, wrong_field: :string)
      end

      it 'does not throw expections when wrong_field passed' do
        expect { test_model.new(wrong_field: 'value') }
          .not_to raise_error described_class::UnpermittedAttributeException
      end

      it 'allows access to fields via methods' do
        t = test_model.new(correct_field: 'value1', wrong_field: 'value2')
        expect(t.correct_field).to eq 'value1'
        expect(t.wrong_field).to eq 'value2'
      end
    end

    xcontext 'with permitting only defined attributes' do
      it 'rejects params which do not appear in mapping on creating new instance' do
        expect { test_model.new(wrong_field: 'value') }
          .to raise_error described_class::UnpermittedAttributeException
      end

      it 'allows access to fields via methods' do
        t = test_model.new('correct_field' => 'value')
        expect(t.correct_field).to eq 'value'
      end
    end
  end
end
