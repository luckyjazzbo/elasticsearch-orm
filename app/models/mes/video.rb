module Mes
  class Video < Mes::Elastic::Model
    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    def_filter :edge_ngrams_2_20, { type: 'edge_ngram', min_gram: 2, max_gram: 20 }
    def_analyzer :lowercased_keyword,   { type: 'custom', tokenizer: 'keyword', filter: ['lowercase'] }
    def_analyzer :default_autocomplete, { type: 'custom', tokenizer: 'standard', filter: ['lowercase', 'edge_ngrams_2_20'] }

    Analyzer::LANGUAGE_ANALYZERS.each do |analyzer|
      analyzer.filter_definitions.each do |name, filter|
        def_filter name, filter
      end
      def_analyzer "glomex_#{analyzer.name}", analyzer.reject_filters { |f| f.end_with?('_stop') }.to_h
      def_analyzer "glomex_#{analyzer.name}_autocomplete", analyzer.reject_filters { |f| f.end_with?('_stop') || f.end_with?('_stemmer') }.add_filters('edge_ngrams_2_20').to_h
    end

    MULTILANG_OPTS = {
      type: :text,
      analyzer: :standard,
      lang_opts: Analyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, { analyzer: "glomex_#{analyzer.name}" }] }.to_h
    }
    MULTILANG_AUTOCOMPLETE_OPTS = {
      type: :text,
      analyzer: :default_autocomplete,
      lang_opts: Analyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, { analyzer: "glomex_#{analyzer.name}_autocomplete" }] }.to_h
    }

    field :tenant_id, type: :keyword
    array :business_rules, type: :keyword
    field :language, type: :text, analyzer: :lowercased_keyword, fielddata: true
    array :geo_locations, type: :text, analyzer: :lowercased_keyword, fielddata: true

    multilang_field :titles, MULTILANG_OPTS.merge(fields: { autocomplete: MULTILANG_AUTOCOMPLETE_OPTS })
    multilang_field :descriptions, MULTILANG_OPTS
    multilang_field :taxonomy_titles, MULTILANG_OPTS.merge(fields: { autocomplete: MULTILANG_AUTOCOMPLETE_OPTS })
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
