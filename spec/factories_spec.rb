require 'spec_helper'

RSpec.describe 'FactoryGirl' do
  include_context 'with mes indices'
  include_context 'with eva indices'

  EVA_FACTORIES = %i(
    eva_elastic_video
  ).freeze

  MES_FACTORIES = %i(
    mes_elastic_video
  ).freeze

  EVA_FACTORIES.each do |factory_name|
    it "defines factory #{factory_name}" do
      FactoryGirl.build(factory_name)
    end

    it "creates object with factory #{factory_name}" do
      expect {
        FactoryGirl.create(factory_name)
        flush_eva_indices
      }.to change {
        ::Eva::Elastic::Resource.count
      }.from(0).to(1)
    end
  end

  MES_FACTORIES.each do |factory_name|
    it "defines factory #{factory_name}" do
      FactoryGirl.build(factory_name)
    end

    it "creates object with factory #{factory_name}" do
      expect {
        FactoryGirl.create(factory_name)
        flush_mes_indices
      }.to change {
        ::Mes::Elastic::Resource.count
      }.from(0).to(1)
    end
  end

  FactoryGirl.factories.map(&:name).each do |factory_name|
    describe "#{factory_name} factory" do
      it 'builds factory' do
        factory = FactoryGirl.build(factory_name)
        if factory.respond_to?(:valid?)
          expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") }
        end
      end

      FactoryGirl.factories[factory_name].definition.defined_traits.map(&:name).each do |trait_name|
        context "with trait #{trait_name}" do
          it 'builds factory' do
            factory = FactoryGirl.build(factory_name, trait_name)
            if factory.respond_to?(:valid?)
              expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") }
            end
          end
        end
      end
    end
  end
end
