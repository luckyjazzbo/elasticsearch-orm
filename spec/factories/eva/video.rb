FactoryGirl.define do
  factory :eva_elastic_video, class: 'Eva::Elastic::Video' do
    modified_at       { Time.now.to_i }
    id                { "v-#{SecureRandom.uuid}" }
    clip_id           { id }
    sequence(:titles) { |n| { 'en' => "Sample video ##{n}", 'de' => "Beispielvideo ##{n}" } }
    clip_duration     100
    descriptions      { { 'en' => 'Awesome video', 'de' => 'Großartiges video' } }
    midroll_offsets   [12.34, 44]

    image(
      'url' => 'http://url.to/poster.jpg'
    )

    ad_tags(
      'prerolls'  => ['tag-1', 'tag-2'],
      'midrolls'  => ['tag-3', 'tag-4'],
      'postrolls' => ['tag-1']
    )

    content_owner(
      'display_name' => 'Awesome TV',
      'link_url'     => 'http://url.to/homepage.de',
      'image'        => { 'url' => 'http://url.to/poster.jpg' }
    )
  end
end
