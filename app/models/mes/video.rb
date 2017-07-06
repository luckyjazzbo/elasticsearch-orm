module Mes
  class Video < Mes::Elastic::Model
    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    def_filter   :autocomplete_filter, { type: 'edge_ngram', min_gram: 1, max_gram: 20 }
    def_analyzer :autocomplete, { type: 'custom', tokenizer: 'standard', filter: ['lowercase', 'autocomplete_filter'] }

    LANGS = %i[default en de fr it es].freeze

    field :tenant_id, type: :keyword

    array :business_rules, type: :keyword

    field :language, type: :keyword
    array :geo_locations, type: :keyword

    multilang_field :titles, type: :text, analyzer: :autocomplete
    multilang_field :descriptions, type: :text
    multilang_field :taxonomy_titles, type: :text
    array :keywords, type: :text

    array :taxonomy_ids, type: :keyword
    object :taxonomy_ids_by_type do
      array :*, type: :keyword
    end

    field :created_at, type: :datetime
    field :modified_at, type: :datetime
    field :deleted_at, type: :datetime

    field :start_date, type: :datetime
    field :end_date, type: :datetime

    field :start_day, type: :date

    array :blacklisted_publisher_ids, type: :keyword
  end
end
