module Mes
  class Taxonomy < Mes::Elastic::Model
    config url: ENV['ELASTICSEARCH_URL'], index: 'lte'

    def_filter :ngrams_2_20, { type: 'ngram', min_gram: 2, max_gram: 20 }
    def_analyzer :default_relaxed, { type: 'custom', tokenizer: 'standard', filter: ['lowercase', 'ngrams_2_20'] }

    Analyzer::LANGUAGE_ANALYZERS.each do |analyzer|
      analyzer.filter_definitions.each do |name, filter|
        def_filter name, filter
      end
      def_analyzer "glomex_#{analyzer.name}_stop_words_indexed", analyzer.reject_filters { |f| f.end_with?('_stop') }.to_h
      def_analyzer "glomex_#{analyzer.name}_relaxed", analyzer.reject_filters { |f| f.end_with?('_stop') || f.end_with?('_stemmer') }.add_filters('ngrams_2_20').to_h
    end

    MULTILANG_STOP_WORDS_INDEXED_OPTS = {
      type: :text,
      analyzer: :standard,
      lang_opts: Analyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, { analyzer: "glomex_#{analyzer.name}_stop_words_indexed" }] }.to_h
    }
    MULTILANG_RELAXED_OPTS = {
      type: :text,
      analyzer: :default_relaxed,
      lang_opts: Analyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, { analyzer: "glomex_#{analyzer.name}_relaxed" }] }.to_h
    }

    field :id, type: :keyword
    field :parent_id, type: :keyword

    object :type do
      field :id, type: :keyword
      multilang_field :titles, type: :text, index: :no, fields: {
        basic:   MULTILANG_STOP_WORDS_INDEXED_OPTS,
        relaxed: MULTILANG_RELAXED_OPTS,
      }
    end

    multilang_field :titles, type: :text, index: :no, fields: {
      basic:   MULTILANG_STOP_WORDS_INDEXED_OPTS,
      relaxed: MULTILANG_RELAXED_OPTS,
    }

    field :created_at, type: :datetime
  end
end
