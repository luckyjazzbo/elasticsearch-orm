require 'spec_helper'

RSpec.describe 'CRUD actions' do
  include_context 'with test indices'

  let(:id1) { '9084eddf-4a48-4e39-afbd-6f3e4e4dc7c5' }
  let(:title1) { 'Test 1' }
  let(:title2) { 'Test 2' }

  let(:subject) { test_model }

  context 'with configured model' do
    before do
      test_model.field :title, :string
      test_model.purge_index!
      test_elastic_flush
    end

    describe '#save' do
      it 'saves new document with id' do
        test_model.upsert(id: id1, title: title1)
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

        expect {
          obj.title = title2
          obj.save
          test_elastic_flush
        }.to change { test_model.find(id1).title }
          .from(title1).to(title2)
      end
    end

    describe '#save!' do
      it 'responds to save!' do
        expect(subject.new).to respond_to(:save!)
      end
    end

    describe '#delete' do
      let!(:document) { test_model.upsert(id: id1, title: title1) }

      it 'deletes a document' do
        test_elastic_flush
        expect {
          document.delete
          test_elastic_flush
        }.to change {
          count_test_documents
        }.from(1).to(0)
      end

      it 'raises lib error when document is absent' do
        document.delete
        expect {
          document.delete
        }.to raise_error(Mes::Elastic::Model::ElasticError)
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
        test_model.upsert(id: id1, title: title1)
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
        test_model.upsert(id: id1, title: title1)
        test_elastic_flush
        expect(test_model.find(id1).new_record?).to be false
      end
    end

    describe '#update_attributes' do
      it 'saves not-saved document with id' do
        test_model.new(id: id1, title: title1).update_attributes
        test_elastic_flush
        loaded_record = test_model.find(id1)
        expect(loaded_record.title).to eq title1
      end

      it 'saves not-saved document without id' do
        obj = test_model.new(title: title1)
        expect { obj.update_attributes }
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

        expect {
          obj.update_attributes(title: title2)
          test_elastic_flush
        }.to change { test_model.find(id1).title }
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
        expect {
          test_model.upsert(title: title1)
          test_elastic_flush
        }.to change { test_model.count }
          .from(0).to(1)
      end

      it 'returns object' do
        obj = test_model.upsert(title: title1)
        test_elastic_flush
        expect(obj).to be_a(test_model)
      end
    end
  end
end
