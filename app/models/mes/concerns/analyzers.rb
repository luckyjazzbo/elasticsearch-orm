module Mes
  module Analyzers
    LanguageAnalyzer = Mes::Elastic::Model::LanguageAnalyzer

    MULTILANG_OPTS = {
      type: :text,
      analyzer: :standard,
      lang_opts: LanguageAnalyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, { analyzer: "glomex_#{analyzer.name}" }] }.to_h
    }
    MULTILANG_STOP_WORDS_INDEXED_OPTS = {
      type: :text,
      analyzer: :standard,
      lang_opts: LanguageAnalyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, { analyzer: "glomex_#{analyzer.name}_stop_words_indexed" }] }.to_h
    }
    MULTILANG_AUTOCOMPLETE_OPTS = {
      type: :text,
      analyzer: :default_autocomplete,
      search_analyzer: :standard,
      lang_opts: LanguageAnalyzer::LANGUAGE_ANALYZERS.map { |analyzer| [analyzer.lang, { analyzer: "glomex_#{analyzer.name}_autocomplete", search_analyzer: "glomex_#{analyzer.name}" }] }.to_h
    }

    def self.included(base)
      base.def_filter :ngrams_2_20, { type: 'ngram', min_gram: 2, max_gram: 20 }
      base.def_analyzer :lowercased_keyword,   { type: 'custom', tokenizer: 'keyword', filter: ['lowercase'] }
      base.def_analyzer :default_autocomplete, { type: 'custom', tokenizer: 'standard', filter: ['lowercase', 'ngrams_2_20'] }

      LanguageAnalyzer::LANGUAGE_ANALYZERS.each do |analyzer|
        analyzer.filter_definitions.each do |name, filter|
          base.def_filter name, filter
        end
        base.def_analyzer "glomex_#{analyzer.name}", analyzer.to_h
        base.def_analyzer "glomex_#{analyzer.name}_stop_words_indexed", analyzer.reject_filters { |f| f.end_with?('_stop') }.to_h
        base.def_analyzer "glomex_#{analyzer.name}_autocomplete", analyzer.reject_filters { |f| f.end_with?('_stop') || f.end_with?('_stemmer') }.add_filters('ngrams_2_20').to_h
      end
    end
  end
end
