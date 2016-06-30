require 'spec_helper'

RSpec.describe 'FactoryGirl' do
  include_context 'with mes indices'
  include_context 'with eva indices'

  [:eva_elastic_video, :mes_elastic_video].each do |factory_name|
    it "defines factory #{factory_name}" do
      FactoryGirl.build(factory_name)
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
