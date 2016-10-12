FactoryGirl.define do
  factory :mes_elastic_video, class: 'Mes::Elastic::Video' do
    id                { "v-#{SecureRandom.uuid}" }
    sequence(:titles) { |n| { 'en' => "Sample video ##{n}", 'de' => "Beispielvideo ##{n}" } }
    clip_duration     100
    descriptions      { { 'en' => 'Awesome video', 'de' => 'Großartiges video' } }
    midroll_offsets   [12.34, 44]
    start_date        nil
    end_date          nil
    created_at        { Time.now.to_i }
    modified_at       { Time.now.to_i }
    taxonomies        ['tx-123']
    is_locked         { false }
    is_deleted        { false }
    product_placement { true }

    image(
      'url' => 'http://url.to/poster.jpg'
    )

    ad_groups([
      {
        'geolocation' => 'en',
        'reach_measured' => {
          'prerolls'  => ['tag-1', 'tag-2'],
          'midrolls'  => ['tag-3', 'tag-4'],
          'postrolls' => ['tag-1']
        }
      },
      {
        'geolocation' => 'de',
        'reach_measured' => {
          'prerolls'  => ['tag-5', 'tag-78'],
          'midrolls'  => ['tag-6', 'tag-41'],
          'postrolls' => ['tag-9']
        }
      }
    ])


    content_owner(
      'display_name' => 'Awesome TV',
      'link_url'     => 'http://url.to/homepage.de',
      'image'        => { 'url' => 'http://url.to/poster.jpg' }
    )

    license_profile(
      'id'                  => 'lp-bunte',
      'created_at'          => Time.now.to_i,
      'modified_at'         => Time.now.to_i,
      'version'             => 1,
      'type'                => 'SYNDICATION',
      'name'                => 'bunte',
      'name_short'          => 'bunte',
      'start_date'          => nil,
      'end_date'            => nil,
      'products'            => [],
      'sales_houses'        => [],
      'geo_locations'       => ['de'],
      'device_classes'      => ['BROWSER'],
      'bandwidth_max'       => { 'BROWSER' => 1024 },
      'max_resolution'      => '1024x768',
      'publisher_whitelist' => [],
      'publisher_blacklist' => [],
      'drm'                 => true,
      'entitlement'         => true
    )
  end
end
