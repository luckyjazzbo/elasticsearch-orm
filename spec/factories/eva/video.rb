FactoryGirl.define do
  factory :eva_elastic_video, class: 'Eva::Elastic::Video' do
    id { "v-#{SecureRandom.uuid}" }
  end
end
