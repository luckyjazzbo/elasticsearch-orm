FactoryGirl.define do
  klass = Mes::Video

  multilang = proc do |&block|
    klass::LANGS.map { |l| [l, block.call(l)] }.to_h
  end

  to_create { |instance| instance.save(refresh: true) }

  factory :video, class: klass do
    id { "v-#{SecureRandom.uuid}" }
    tenant_id { "t-#{SecureRandom.uuid}" }
    business_rules { %w[stored_to_vas available_on_portal] }
    language 'de'
    geo_locations ['de']

    sequence(:titles) { |n| multilang.call { |l| "Title #{l} #{n}" } }
    sequence(:descriptions) { |n| multilang.call { |l| "Descriptions #{l} #{n}" } }
    sequence(:taxonomy_titles) { |n| multilang.call { |l| "Taxonomy #{l} #{n}" } }
    keywords { ['jennifer lopez', 'lindsey stirling', 'brad pitt'] }

    taxonomy_ids { Array.new(5) { "tx-#{SecureRandom.uuid}" } }

    modified_at Time.current
    deleted_at nil

    start_date { 10.minutes.ago }
    end_date { 10.minutes.from_now }
    start_day { 1.minutes.ago.to_date }
    blacklisted_publisher_ids { ['t-blacklisted'] }
  end
end
