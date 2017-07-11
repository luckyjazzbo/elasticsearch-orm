module Mes
  class Video < Mes::Elastic::Model
    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    def_filter :ngrams_2_20, { type: 'edge_ngram', min_gram: 2, max_gram: 20 }
    def_analyzer :lowercased_keyword,   { type: 'custom', tokenizer: 'keyword', filter: ['lowercase'] }
    def_analyzer :default_autocomplete, { type: 'custom', tokenizer: 'standard', filter: ['lowercase', 'ngrams_2_20'] }

    Analyzer::LANGUAGE_ANALYZERS.each do |analyzer|
      analyzer.filter.each do |name, definition|
        def_filter name, definition
      end
      def_analyzer "glomex_#{analyzer.name}", analyzer.analyzer
      def_analyzer "glomex_#{analyzer.name}_autocomplete", analyzer.extend_analyzer(filter: ['ngrams_2_20'])
    end

    MULTILANG_ANALYZER = {
      analyzer: :standard,
      lang_analyzers: Analyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.short_name, "glomex_#{analyzer.name}"] }.to_h
    }
    MULTILANG_AUTOCOMPLETE_ANALYZER = {
      analyzer: :default_autocomplete,
      lang_analyzers: Analyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.short_name, "glomex_#{analyzer.name}_autocomplete"] }.to_h
    }

    field :tenant_id, type: :keyword
    array :business_rules, type: :keyword
    field :language, type: :text, analyzer: :lowercased_keyword, fielddata: true
    array :geo_locations, type: :text, analyzer: :lowercased_keyword, fielddata: true

    multilang_field :titles, MULTILANG_ANALYZER.merge(type: :text, fields: { autocomplete: { type: :text }.merge(MULTILANG_AUTOCOMPLETE_ANALYZER) })
    multilang_field :descriptions, MULTILANG_ANALYZER.merge(type: :text)
    multilang_field :taxonomy_titles, MULTILANG_ANALYZER.merge(type: :text, fields: { autocomplete: { type: :text }.merge(MULTILANG_AUTOCOMPLETE_ANALYZER) })
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
