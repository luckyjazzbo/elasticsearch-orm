FactoryGirl.define do
  multilang = proc do |&block|
    Mes::Elastic::Model::Analyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, block.call(analyzer.lang)] }.to_h
  end

  to_create { |instance| instance.save(refresh: true) }

  factory :taxonomy, class: Mes::Taxonomy do
    id { "tx-#{SecureRandom.uuid}" }
    parent_id { nil }

    type do
      {
        'id' => "tx-#{SecureRandom.uuid}",
        'titles' => multilang.call { |l| "Metaphor #{l}" },
      }
    end

    sequence(:titles) { |n| multilang.call { |l| "Title #{l} #{n}" } }

    created_at Time.current
  end
end
