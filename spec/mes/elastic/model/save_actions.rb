require 'spec_helper'

RSpec.shared_context 'save actions' do
  let(:id1) { '9084eddf-4a48-4e39-afbd-6f3e4e4dc7c5' }
  let(:title1) { 'Test 1' }
  let(:title2) { 'Test 2' }

  context 'with configured model' do
    before do
      test_model.field :title, :string
      test_model.purge_index!
      test_elastic_flush
    end

    describe '#save' do
      it 'saves new document with id' do
        test_model.new(id: id1, title: title1).save
        test_elastic_flush
        loaded_record = test_model.find(id1)
        expect(loaded_record.title).to eq title1
      end

      it 'saves new document with nil id' do
        obj = test_model.new(title: title1)
        obj.id = nil
        expect { obj.save }
          .to change { obj.id.nil? }
          .from(true).to(false)
        test_elastic_flush
        loaded_record = test_model.find(obj.id)
        expect(loaded_record.title).to eq title1
      end

      it 'saves new document without id' do
        obj = test_model.new(title: title1)
        expect { obj.save }
          .to change { obj.id.nil? }
          .from(true).to(false)
        test_elastic_flush
        loaded_record = test_model.find(obj.id)
        expect(loaded_record.title).to eq title1
      end

      it 'updates existing document' do
        obj = test_model.new(id: id1, title: title1)
        obj.save
        test_elastic_flush

        expect do
          obj.title = title2
          obj.save
          test_elastic_flush
        end.to change { test_model.find(id1).title }
          .from(title1).to(title2)
      end
    end

    describe '#persisted?' do
      it 'is false for new records' do
        expect(test_model.new(id: id1, title: title1).persisted?).to be false
      end

      it 'is true for saved records' do
        obj = test_model.new(id: id1, title: title1)
        expect { obj.save }
          .to change { obj.persisted? }
          .from(false).to(true)
      end

      it 'is true for loaded records' do
        test_model.new(id: id1, title: title1).save
        test_elastic_flush
        expect(test_model.find(id1).persisted?).to be true
      end
    end

    describe '.new_record?' do
      it 'is true for new records' do
        expect(test_model.new(id: id1, title: title1).new_record?).to be true
      end

      it 'is false for saved records' do
        obj = test_model.new(id: id1, title: title1)
        expect { obj.save }
          .to change { obj.new_record? }
          .from(true).to(false)
      end

      it 'is false for loaded records' do
        test_model.new(id: id1, title: title1).save
        test_elastic_flush
        expect(test_model.find(id1).new_record?).to be false
      end
    end

    describe '#update' do
      it 'saves not-saved document with id' do
        test_model.new(id: id1, title: title1).update
        test_elastic_flush
        loaded_record = test_model.find(id1)
        expect(loaded_record.title).to eq title1
      end

      it 'saves not-saved document without id' do
        obj = test_model.new(title: title1)
        expect { obj.update }
          .to change { obj.id.nil? }
          .from(true).to(false)
        test_elastic_flush
        loaded_record = test_model.find(obj.id)
        expect(loaded_record.title).to eq title1
      end

      it 'updates existing document' do
        obj = test_model.new(id: id1, title: title1)
        obj.save
        test_elastic_flush

        expect do
          obj.update title: title2
          test_elastic_flush
        end.to change { test_model.find(id1).title }
          .from(title1).to(title2)
      end
    end

    describe '.upsert' do
      it 'saves new document with id' do
        test_model.upsert(id: id1, title: title1)
        test_elastic_flush
        loaded_record = test_model.find(id1)
        expect(loaded_record.title).to eq title1
      end

      it 'saves new document without id' do
        expect do
          test_model.upsert(title: title1)
          test_elastic_flush
        end.to change { test_model.count }
          .from(0).to(1)
      end
    end
  end
end
