module ElasticsearchOrm
  class Model
    class LanguageAnalyzer
      attr_reader :name, :lang, :analyzer_definition, :filter_definitions

      def initialize(name:, lang:, analyzer_definition:, filter_definitions:)
        @name = name
        @lang = lang
        @analyzer_definition = analyzer_definition
        @filter_definitions = filter_definitions
      end

      def reject_filters(&block)
        dup.tap do |analyzer|
          analyzer.analyzer_definition[:filter].reject!(&block)
        end
      end

      def add_filters(*filters)
        dup.tap do |analyzer|
          analyzer.analyzer_definition[:filter] += filters
        end
      end

      def dup
        LanguageAnalyzer.new(name: name, lang: lang, analyzer_definition: analyzer_definition.deep_dup, filter_definitions: filter_definitions.deep_dup)
      end

      def to_h
        analyzer_definition
      end

      LANGUAGE_ANALYZERS = [
        # new(
        #   name: :arabic,
        #   lang: :ar,
        #   filter_definitions: {
        #     arabic_stop: { type: 'stop', stopwords: '_arabic_' },
        #     arabic_stemmer: { type: 'stemmer', language: 'arabic' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'arabic_stop', 'arabic_normalization', 'arabic_stemmer']
        #   }
        # ),
        # new(
        #   name: :armenian,
        #   lang: :hy,
        #   filter_definitions: {
        #     armenian_stop: { type: 'stop', stopwords: '_armenian_' },
        #     armenian_stemmer: { type: 'stemmer', language: 'armenian' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'armenian_stop', 'armenian_stemmer']
        #   }
        # ),
        # new(
        #   name: :basque,
        #   lang: :eu,
        #   filter_definitions: {
        #     basque_stop: { type: 'stop', stopwords: '_basque_' },
        #     basque_stemmer: { type: 'stemmer', language: 'basque' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'basque_stop', 'basque_stemmer']
        #   }
        # ),
        # new(
        #   name: :brazilian,
        #   lang: :bg,
        #   filter_definitions: {
        #     brazilian_stop: { type: 'stop', stopwords: '_brazilian_' },
        #     brazilian_stemmer: { type: 'stemmer', language: 'brazilian' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'brazilian_stop', 'brazilian_stemmer']
        #   }
        # ),
        # new(
        #   name: :catalan,
        #   lang: :ca,
        #   filter_definitions: {
        #     catalan_elision: { type: 'elision', 'articles':   [ 'd', 'l', 'm', 'n', 's', 't'] },
        #     catalan_stop: { type: 'stop', stopwords: '_catalan_' },
        #     catalan_stemmer: { type: 'stemmer', language: 'catalan' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['catalan_elision', 'lowercase', 'catalan_stop', 'catalan_stemmer']
        #   }
        # ),
        # new(
        #   name: :czech,
        #   lang: :cs,
        #   filter_definitions: {
        #     czech_stop: { type: 'stop', stopwords: '_czech_' },
        #     czech_stemmer: { type: 'stemmer', language: 'czech' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'czech_stop', 'czech_stemmer']
        #   }
        # ),
        # new(
        #   name: :danish,
        #   lang: :da,
        #   filter_definitions: {
        #     danish_stop: { type: 'stop', stopwords: '_danish_' },
        #     danish_stemmer: { type: 'stemmer', language: 'danish' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'danish_stop', 'danish_stemmer']
        #   }
        # ),
        # new(
        #   name: :dutch,
        #   lang: :nl,
        #   filter_definitions: {
        #     dutch_stop: { type: 'stop', stopwords: '_dutch_' },
        #     dutch_stemmer: { type: 'stemmer', language: 'dutch' },
        #     dutch_override: { type: 'stemmer_override', 'rules': [ 'fiets=>fiets', 'bromfiets=>bromfiets', 'ei=>eier', 'kind=>kinder' ] }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'dutch_stop', 'dutch_override', 'dutch_stemmer']
        #   }
        # ),
        new(
          name: :english,
          lang: :en,
          filter_definitions: {
            english_stop: { type: 'stop', stopwords: '_english_' },
            english_stemmer: { type: 'stemmer', language: 'english' },
            english_possessive_stemmer: { type: 'stemmer', language: 'possessive_english' }
          },
          analyzer_definition: {
            tokenizer: 'standard',
            filter: ['english_possessive_stemmer', 'lowercase', 'english_stop', 'english_stemmer']
          }
        ),
        # new(
        #   name: :finnish,
        #   lang: :fi,
        #   filter_definitions: {
        #     finnish_stop: { type: 'stop', stopwords: '_finnish_' },
        #     finnish_stemmer: { type: 'stemmer', language: 'finnish' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'finnish_stop', 'finnish_stemmer']
        #   }
        # ),
        new(
          name: :french,
          lang: :fr,
          filter_definitions: {
            french_elision: { type: 'elision', 'articles_case': true, 'articles': [ 'l', 'm', 't', 'qu', 'n', 's', 'j', 'd', 'c', 'jusqu', 'quoiqu', 'lorsqu', 'puisqu' ] },
            french_stop: { type: 'stop', stopwords: '_french_' },
            french_stemmer: { type: 'stemmer', language: 'light_french' }
          },
          analyzer_definition: {
            tokenizer: 'standard',
            filter: ['french_elision', 'lowercase', 'french_stop', 'french_stemmer']
          }
        ),
        # new(
        #   name: :galician,
        #   lang: :gl,
        #   filter_definitions: {
        #     galician_stop: { type: 'stop', stopwords: '_galician_' },
        #     galician_stemmer: { type: 'stemmer', language: 'galician' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'galician_stop', 'galician_stemmer']
        #   }
        # ),
        new(
          name: :german,
          lang: :de,
          filter_definitions: {
            german_stop: { type: 'stop', stopwords: '_german_' },
            german_stemmer: { type: 'stemmer', language: 'light_german' }
          },
          analyzer_definition: {
            tokenizer: 'standard',
            filter: ['lowercase', 'german_stop', 'german_normalization', 'german_stemmer']
          }
        ),
        # new(
        #   name: :greek,
        #   lang: :el,
        #   filter_definitions: {
        #     greek_stop: { type: 'stop', stopwords: '_greek_' },
        #     greek_lowercase: { type: 'lowercase', language: 'greek' },
        #     greek_stemmer: { type: 'stemmer', language: 'greek' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['greek_lowercase', 'greek_stop', 'greek_stemmer']
        #   }
        # ),
        # new(
        #   name: :hindi,
        #   lang: :hi,
        #   filter_definitions: {
        #     hindi_stop: { type: 'stop', stopwords: '_hindi_' },
        #     hindi_stemmer: { type: 'stemmer', language: 'hindi' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'indic_normalization', 'hindi_normalization', 'hindi_stop', 'hindi_stemmer']
        #   }
        # ),
        # new(
        #   name: :hungarian,
        #   lang: :hu,
        #   filter_definitions: {
        #     hungarian_stop: { type: 'stop', stopwords: '_hungarian_' },
        #     hungarian_stemmer: { type: 'stemmer', language: 'hungarian' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'hungarian_stop', 'hungarian_stemmer']
        #   }
        # ),
        # new(
        #   name: :indonesian,
        #   lang: :id,
        #   filter_definitions: {
        #     indonesian_stop: { type: 'stop', stopwords: '_indonesian_' },
        #     indonesian_stemmer: { type: 'stemmer', language: 'indonesian' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'indonesian_stop', 'indonesian_stemmer']
        #   }
        # ),
        # new(
        #   name: :irish,
        #   lang: :ga,
        #   filter_definitions: {
        #     irish_elision: { type: 'elision', 'articles': [ 'h', 'n', 't' ] },
        #     irish_stop: { type: 'stop', stopwords: '_irish_' },
        #     irish_lowercase: { type: 'lowercase', language: 'irish' },
        #     irish_stemmer: { type: 'stemmer', language: 'irish' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['irish_stop', 'irish_elision', 'irish_lowercase', 'irish_stemmer']
        #   }
        # ),
        new(
          name: :italian,
          lang: :it,
          filter_definitions: {
            italian_elision: { type: 'elision', 'articles': [ 'c', 'l', 'all', 'dall', 'dell', 'nell', 'sull', 'coll', 'pell', 'gl', 'agl', 'dagl', 'degl', 'negl', 'sugl', 'un', 'm', 't', 's', 'v', 'd' ] },
            italian_stop: { type: 'stop', stopwords: '_italian_' },
            italian_stemmer: { type: 'stemmer', language: 'light_italian' }
          },
          analyzer_definition: {
            tokenizer: 'standard',
            filter: ['italian_elision', 'lowercase', 'italian_stop', 'italian_stemmer']
          }
        ),
        # new(
        #   name: :latvian,
        #   lang: :lv,
        #   filter_definitions: {
        #     latvian_stop: { type: 'stop', stopwords: '_latvian_' },
        #     latvian_stemmer: { type: 'stemmer', language: 'latvian' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'latvian_stop', 'latvian_stemmer']
        #   }
        # ),
        # new(
        #   name: :lithuanian,
        #   lang: :lt,
        #   filter_definitions: {
        #     lithuanian_stop: { type: 'stop', stopwords: '_lithuanian_' },
        #     lithuanian_stemmer: { type: 'stemmer', language: 'lithuanian' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'lithuanian_stop', 'lithuanian_stemmer']
        #   }
        # ),
        # new(
        #   name: :norwegian,
        #   lang: :no,
        #   filter_definitions: {
        #     norwegian_stop: { type: 'stop', stopwords: '_norwegian_' },
        #     norwegian_stemmer: { type: 'stemmer', language: 'norwegian' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'norwegian_stop', 'norwegian_stemmer']
        #   }
        # ),
        # new(
        #   name: :portuguese,
        #   lang: :pt,
        #   filter_definitions: {
        #     portuguese_stop: { type: 'stop', stopwords: '_portuguese_' },
        #     portuguese_stemmer: { type: 'stemmer', language: 'light_portuguese' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'portuguese_stop', 'portuguese_stemmer']
        #   }
        # ),
        # new(
        #   name: :romanian,
        #   lang: :ro,
        #   filter_definitions: {
        #     romanian_stop: { type: 'stop', stopwords: '_romanian_' },
        #     romanian_stemmer: { type: 'stemmer', language: 'romanian' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'romanian_stop', 'romanian_stemmer']
        #   }
        # ),
        new(
          name: :russian,
          lang: :ru,
          filter_definitions: {
            russian_stop: { type: 'stop', stopwords: '_russian_' },
            russian_stemmer: { type: 'stemmer', language: 'russian' }
          },
          analyzer_definition: {
            tokenizer: 'standard',
            filter: ['lowercase', 'russian_stop', 'russian_stemmer']
          }
        ),
        new(
          name: :spanish,
          lang: :es,
          filter_definitions: {
            spanish_stop: { type: 'stop', stopwords: '_spanish_' },
            spanish_stemmer: { type: 'stemmer', language: 'light_spanish' }
          },
          analyzer_definition: {
            tokenizer: 'standard',
            filter: ['lowercase', 'spanish_stop', 'spanish_stemmer']
          }
        ),
        # new(
        #   name: :swedish,
        #   lang: :sv,
        #   filter_definitions: {
        #     swedish_stop: { type: 'stop', stopwords: '_swedish_' },
        #     swedish_stemmer: { type: 'stemmer', language: 'swedish' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['lowercase', 'swedish_stop', 'swedish_stemmer']
        #   }
        # ),
        # new(
        #   name: :turkish,
        #   lang: :tr,
        #   filter_definitions: {
        #     turkish_stop: { type: 'stop', stopwords: '_turkish_' },
        #     turkish_lowercase: { type: 'lowercase', language: 'turkish' },
        #     turkish_stemmer: { type: 'stemmer', language: 'turkish' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'standard',
        #     filter: ['apostrophe', 'turkish_lowercase', 'turkish_stop', 'turkish_stemmer']
        #   }
        # ),
        # new(
        #   name: :thai,
        #   lang: :th,
        #   filter_definitions: {
        #     thai_stop: { type: 'stop', stopwords: '_thai_' }
        #   },
        #   analyzer_definition: {
        #     tokenizer: 'thai',
        #     filter: ['lowercase', 'thai_stop']
        #   }
        # ),
      ].freeze
    end
  end
end
