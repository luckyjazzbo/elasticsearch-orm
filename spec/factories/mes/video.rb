FactoryGirl.define do
  factory :mes_elastic_video, class: 'Mes::Elastic::Video' do
    id { "v-#{SecureRandom.uuid}" }
  end
end
