FactoryGirl.define do
  multilang = proc do |&block|
    Mes::Elastic::Model::LanguageAnalyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, block.call(analyzer.lang)] }.to_h
  end

  to_create { |instance| instance.save(refresh: true) }

  factory :video, class: Mes::Video do
    id { "v-#{SecureRandom.uuid.gsub(/\W/, '')}" }
    source_id { SecureRandom.uuid.gsub(/\W/, '') }
    tenant_id { 't-co' }
    business_rules { %w[stored_to_vas available_on_portal] }
    language 'de'
    geo_locations %w[de en]
    ad_countries %w[de en]

    sequence(:titles) { |n| multilang.call { |l| "Title #{l} #{n}" } }
    sequence(:descriptions) { |n| multilang.call { |l| "Descriptions #{l} #{n}" } }
    sequence(:taxonomy_titles) { |n| multilang.call { |l| "Taxonomy #{l} #{n}" } }
    keywords { ['jennifer lopez', 'lindsey stirling', 'brad pitt'] }

    taxonomy_ids { (1..5).map { |n| "tx-#{n}" } }

    modified_at Time.current
    created_at Time.current
    deleted_at nil

    start_date { 10.minutes.ago }
    end_date { 10.minutes.from_now }
    portal_release_date { 10.minutes.ago }
    start_day { 1.minutes.ago.to_date }
    blacklisted_publisher_ids { ['t-blacklisted'] }
    whitelisted_publisher_ids { ['t-whitelisted'] }

    inspection_state 'open'

    num_views 1000
    num_views_by_period(
      '10min':     1,
      '30min':     10,
      '1hour':     20,
      '3hours':    30,
      'today':     40,
      'yesterday': 50,
      'week':      60,
      'month':     70
    )
    num_views_updated_at { Time.current }
  end
end
