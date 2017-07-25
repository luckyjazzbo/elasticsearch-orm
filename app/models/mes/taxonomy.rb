module Mes
  class Taxonomy < Mes::Elastic::Model
    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    field :id, type: :keyword
    field :parent_id, type: :keyword

    object :type do
      field :id, type: :keyword
      multilang_field :titles, type: :text, index: :no, fields: {
        regular:      Analyzers::MULTILANG_STOP_WORDS_INDEXED_OPTS,
        autocomplete: Analyzers::MULTILANG_AUTOCOMPLETE_OPTS,
      }
    end

    multilang_field :titles, type: :text, index: :no, fields: {
      regular:      Analyzers::MULTILANG_STOP_WORDS_INDEXED_OPTS,
      autocomplete: Analyzers::MULTILANG_AUTOCOMPLETE_OPTS,
    }

    field :created_at, type: :datetime
  end
end
