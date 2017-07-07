module Mes
  class Video < Mes::Elastic::Model
    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    def_filter :edge_ngrams, { type: 'edge_ngram', min_gram: 1, max_gram: 20 }
    def_analyzer :lowercased_keyword,   { type: 'custom', tokenizer: 'keyword', filter: ['lowercase'] }
    def_analyzer :default_autocomplete, { type: 'custom', tokenizer: 'standard', filter: ['lowercase', 'edge_ngrams'] }

    Analyzer::LANGUAGE_ANALYZERS.each do |analyzer|
      analyzer.filter.each do |name, definition|
        def_filter name, definition
      end
      def_analyzer "#{analyzer.name}_autocomplete", analyzer.extend_analyzer(filter: ['edge_ngrams'])
    end

    field :tenant_id, type: :keyword
    array :business_rules, type: :keyword
    field :language, type: :text, analyzer: :lowercased_keyword
    array :geo_locations, type: :text, analyzer: :lowercased_keyword

    multilang_field :titles, type: :text,
                             analyzer: :default_autocomplete,
                             lang_analyzers: Analyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.short_name, "#{analyzer.name}_autocomplete"] }.to_h
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
