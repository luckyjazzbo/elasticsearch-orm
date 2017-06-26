module Mes
  class Video < Mes::Elastic::Model
    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    LANGS = %i[default en de].freeze

    field :tenant_id, type: :keyword

    array :business_rules, type: :keyword

    field :language, type: :keyword
    array :geo_locations, type: :keyword

    multilang_field :titles, type: :text
    multilang_field :descriptions, type: :text
    multilang_field :taxonomy_titles, type: :text
    array :keywords, type: :text

    array :taxonomy_ids, type: :keyword
    object :taxonomy_ids_by_type do
      array :*, type: :keyword
    end

    field :modified_at, type: :datetime
    field :deleted_at, type: :datetime

    field :start_date, type: :datetime
    field :end_date, type: :datetime

    field :start_day, type: :date

    array :blacklisted_publisher_ids, type: :keyword
  end
end
