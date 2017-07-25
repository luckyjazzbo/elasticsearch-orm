module Mes
  class Taxonomy < Mes::Elastic::Model
    include Analyzers

    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    field :id, type: :keyword
    field :parent_id, type: :keyword

    object :type do
      field :id, type: :keyword
      multilang_field :titles, type: :text, index: :no, fields: {
        regular:      MULTILANG_STOP_WORDS_INDEXED_OPTS,
        autocomplete: MULTILANG_AUTOCOMPLETE_OPTS,
      }
    end

    multilang_field :titles, type: :text, index: :no, fields: {
      regular:      MULTILANG_STOP_WORDS_INDEXED_OPTS,
      autocomplete: MULTILANG_AUTOCOMPLETE_OPTS,
    }

    field :created_at, type: :datetime
  end
end
