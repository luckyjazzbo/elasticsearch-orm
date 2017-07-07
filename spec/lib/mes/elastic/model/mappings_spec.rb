require 'spec_helper'

RSpec.describe 'Mappings' do
  include_context 'with test indices'

  describe '.field' do
    let(:subject) { test_model }

    it 'defines id field by default' do
      expect(test_model.field?(:id)).to be_truthy
    end

    it 'defines a field in mapping' do
      expect { test_model.field :test_field, :text }
        .to change { test_model.field? :test_field }
        .from(false).to(true)
    end

    it 'defines readers for fields' do
      test_model.field :test_field, :text
      obj = test_model.new test_field: 'value'
      expect(obj.test_field).to eq 'value'
    end

    it 'defines writers for fields' do
      test_model.field :test_field, :text
      obj = test_model.new test_field: 'value'
      expect { obj.test_field = 'new value' }
        .to change { obj.test_field }
        .from('value').to('new value')
    end

    it 'fails to create field with reserved names' do
      expect { test_model.field :send, :text }
        .to raise_error Mes::Elastic::Model::UnpermittedFieldNameError
    end
  end

  describe '.array' do
    let(:subject) { test_model }

    it 'defines a field in mapping' do
      expect { test_model.array :test_field, type: :text }
        .to change { test_model.field? :test_field }
        .from(false).to(true)
    end

    it 'defines readers for fields' do
      test_model.array :test_field, type: :text
      obj = test_model.new test_field: ['value']
      expect(obj.test_field).to eq ['value']
    end

    it 'defines writers for fields' do
      test_model.array :test_field, type: :text
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

          array :object_field_as_array, type: :object do
            field :object_subfield, type: :integer
          end
        end
        config_test_model_class Mes::ShallowObjectTestModel
      end

      it 'builds correct mapping' do
        expect(subject.mapping[:properties][:object_field]).to eq(
          properties: {
            object_subfield: { type: :integer }
          }
        )
      end

      it 'builds correct mapping for array of objects' do
        expect(subject.mapping[:properties][:object_field_as_array]).to eq(
          properties: {
            object_subfield: { type: :integer }
          }
        )
      end

      it 'defines an accessor' do
        expect(instance).to respond_to(:object_field)
        expect(instance).to respond_to(:object_field_as_array)
      end

      it 'allows to set subfields' do
        expect(instance.object_field).to respond_to(:object_subfield=)
      end

      it 'reads the same value after setting of subfields' do
        instance.object_field.object_subfield = 1
        expect(instance.object_field.object_subfield).to eq(1)
      end

      it 'allows assigning attributes for array' do
        instance.object_field_as_array = [ {object_subfield: 1}, {object_subfield: 2} ]
        expect(instance.object_field_as_array[0].object_subfield).to eq(1)
        expect(instance.object_field_as_array[1].object_subfield).to eq(2)
      end

      it 'allows initializing with array' do
        instance = subject.new(object_field_as_array: [ {object_subfield: 1}, {object_subfield: 2} ])
        expect(instance.object_field_as_array[0].object_subfield).to eq(1)
        expect(instance.object_field_as_array[1].object_subfield).to eq(2)
      end

      it 'allows to change items in array after assigning' do
        instance = subject.new(object_field_as_array: [ {object_subfield: 1}, {object_subfield: 2} ])
        instance.object_field_as_array[1].object_subfield = 3
        expect(instance.object_field_as_array[1].object_subfield).to eq(3)
      end

      it 'allows to reassign items to array after assigning' do
        instance = subject.new(object_field_as_array: [ {object_subfield: 1}, {object_subfield: 2} ])
        instance.object_field_as_array[1] = { object_subfield: 3}
        expect(instance.object_field_as_array[1].object_subfield).to eq(3)
      end

      it 'allows to use each/map/etc. when array field' do
        instance = subject.new(object_field_as_array: [ {object_subfield: 1}, {object_subfield: 2} ])
        instance.object_field_as_array.each { |x| x.object_subfield += 10 }
        expect(instance.object_field_as_array[0].object_subfield).to eq(11)
        expect(instance.object_field_as_array[1].object_subfield).to eq(12)
      end

      it 'allows to append items to array after assigning' do
        instance = subject.new(object_field_as_array: [ {object_subfield: 1}, {object_subfield: 2} ])
        instance.object_field_as_array << { object_subfield: 3}
        expect(instance.object_field_as_array[2].object_subfield).to eq(3)
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
        expect(subject.mapping[:properties][:object_field]).to eq(
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
      test_model.field :correct_field, :text
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

  describe '.multilang_field' do
    subject { test_model }
    let(:multilang_mapping) do
      Mes::Elastic::Model::Analyzer::LANGUAGE_ANALYZERS
        .map { |analyzer| [analyzer.short_name, { type: :text, analyzer: analyzer.name }] }
        .to_h
        .merge(default: { type: :text })
    end

    it 'defines fields' do
      expect { subject.multilang_field :titles, type: :text }
        .to(change { subject.field? :titles }.from(false).to(true))

      expect(subject.mapping).to eq(
        dynamic_templates: [{ 'titles_multilang' => { path_match: "titles.*", mapping: { type: :text }}}],
        properties: {
          id: { type: :keyword },
          titles: { properties: multilang_mapping }
        }
      )
    end

    context 'with inner fields' do
      it 'defines fields' do
        subject.multilang_field :titles, type: :text
        subject.object :root_object do
          multilang_field :titles, type: :text
        end

        expect(subject.mapping).to eq(
          dynamic_templates: [
            { 'titles_multilang' => { path_match: 'titles.*', mapping: { type: :text }}},
            { 'root_object_titles_multilang' => { path_match: 'root_object.titles.*', mapping: { type: :text }}},
          ],
          properties: {
            id: { type: :keyword },
            titles: { properties: multilang_mapping },
            root_object: {
              properties: {
                titles: { properties: multilang_mapping }
              }
            }
          }
        )
      end
    end
  end

  context 'dynamic templates' do
    let(:subject) { test_model }

    before do
      purge_test_index
    end

    it 'defines fields' do
      subject.object :titles do
        field :*, type: :text
      end

      expect(subject.mapping).to eq(
        dynamic_templates: [{ 'titles_all' => { path_match: "titles.*", mapping: { type: :text }}}],
        properties: { id: { type: :keyword }, titles: { properties: {} } }
      )
    end

    it 'works' do
      subject.object :titles do
        field :*, type: :keyword
      end

      subject.create_mapping
      subject.new(titles: { test_field: 'bla' }).save
      mapping = subject.client.indices.get_mapping(index: test_index, type: test_type)

      actual_type = mapping.dig(
        test_index, 'mappings', test_type,
        'properties', 'titles',
        'properties', 'test_field', 'type'
      )
      expect(actual_type).to eq('keyword')
    end
  end

  context 'date fields' do
    shared_examples 'with field' do |type, value|
      let(:model) do
        test_model.tap { |m| m.field :start_date, type }
      end

      let(:object) { model.new(start_date: value) }

      before do
        model.purge_index!
        model.create_mapping
      end

      it 'stores value' do
        expect { object.save! }.not_to raise_error
      end

      it 'returns exactly same value' do
        object.save!(refresh: true)

        expect(model.all.first.start_date).to eq(value)
      end
    end

    it_behaves_like 'with field', :date, Date.current
    it_behaves_like 'with field', :datetime, Time.current.change(usec: 0)
  end
end
