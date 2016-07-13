FactoryGirl.define do
  factory :eva_elastic_video, class: 'Eva::Elastic::Video' do
    id                     { "v-#{SecureRandom.uuid}" }
    duration               100.1
    sequence(:title)       { |n| { 'en' => "Sample video ##{n}", 'de' => "Beispielvideo ##{n}" } }
    sequence(:description) { |n| { 'en' => "Awesome video ##{n}", 'de' => "Großartiges video ##{n}" } }
    keywords               %w(video awesomeness)
    language               'en'
    release_date           '2010'
    created_at             { Time.now.to_i }
    modified_at            { Time.now.to_i }
    status                 'READY'
  end
end
