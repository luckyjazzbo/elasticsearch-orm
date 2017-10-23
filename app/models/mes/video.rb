module Mes
  class Video < Mes::Elastic::Model
    include Analyzers

    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    field :source_id, type: :keyword
    field :tenant_id, type: :keyword
    array :business_rules, type: :keyword
    field :language, type: :text, analyzer: :lowercased_keyword, fielddata: true
    array :geo_locations, type: :text, analyzer: :lowercased_keyword, fielddata: true

    multilang_field :titles, type: :text, index: :no, fields: {
      regular:      MULTILANG_STOP_WORDS_INDEXED_OPTS,
      autocomplete: MULTILANG_AUTOCOMPLETE_OPTS
    }
    multilang_field :descriptions, MULTILANG_OPTS
    multilang_field :taxonomy_titles, type: :text, index: :no, fields: {
      regular:      MULTILANG_STOP_WORDS_INDEXED_OPTS,
      autocomplete: MULTILANG_AUTOCOMPLETE_OPTS
    }
    array :keywords, type: :text

    array :taxonomy_ids, type: :keyword
    object :taxonomy_ids_by_type do
      array :*, type: :keyword
    end

    field :num_views, type: :long
    object :num_views_by_period do
      field :'10min',     type: :long
      field :'30min',     type: :long
      field :'1hour',     type: :long
      field :'3hours',    type: :long
      field :'today',     type: :long
      field :'yesterday', type: :long
      field :'week',      type: :long
      field :'month',     type: :long
    end
    field :num_views_updated_at, type: :datetime

    field :created_at, type: :datetime
    field :modified_at, type: :datetime
    field :deleted_at, type: :datetime

    field :start_date, type: :datetime
    field :end_date, type: :datetime
    field :portal_release_date, type: :datetime
    field :portal_end_date, type: :datetime

    field :start_day, type: :date

    array :blacklisted_publisher_ids, type: :keyword
  end
end
