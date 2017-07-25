module Mes
  class Video < Mes::Elastic::Model
    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    field :tenant_id, type: :keyword
    array :business_rules, type: :keyword
    field :language, type: :text, analyzer: :lowercased_keyword, fielddata: true
    array :geo_locations, type: :text, analyzer: :lowercased_keyword, fielddata: true

    multilang_field :titles, type: :text, index: :no, fields: {
      regular:      Analyzers::MULTILANG_STOP_WORDS_INDEXED_OPTS,
      autocomplete: Analyzers::MULTILANG_AUTOCOMPLETE_OPTS
    }
    multilang_field :descriptions, Analyzers::MULTILANG_OPTS
    multilang_field :taxonomy_titles, type: :text, index: :no, fields: {
      regular:      Analyzers::MULTILANG_STOP_WORDS_INDEXED_OPTS,
      autocomplete: Analyzers::MULTILANG_AUTOCOMPLETE_OPTS
    }
    array :keywords, type: :text

    array :taxonomy_ids, type: :keyword
    object :taxonomy_ids_by_type do
      array :*, type: :keyword
    end

    field :num_views, type: :long

    field :created_at, type: :datetime
    field :modified_at, type: :datetime
    field :deleted_at, type: :datetime

    field :start_date, type: :datetime
    field :end_date, type: :datetime

    field :start_day, type: :date

    array :blacklisted_publisher_ids, type: :keyword
  end
end
