module Mes
  module Elastic
    class Model
      class Analyzer
        attr_reader :name, :short_name, :analyzer, :filter

        def initialize(name:, short_name:, analyzer:, filter:)
          @name = name
          @short_name = short_name
          @analyzer = analyzer
          @filter = filter
        end

        def extend_analyzer(opts)
          analyzer.deep_dup.tap do |copy|
            copy[:type] = 'custom'
            copy[:filter] += Array(opts[:filter])
          end
        end

        LANGUAGE_ANALYZERS = [
          new(
            name: :arabic,
            short_name: :ar,
            filter: {
              arabic_stop: { type: 'stop', stopwords: '_arabic_' },
              arabic_stemmer: { type: 'stemmer', language: 'arabic' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'arabic_normalization', 'arabic_stemmer']
            }
          ),
          new(
            name: :armenian,
            short_name: :hy,
            filter: {
              armenian_stop: { type: 'stop', stopwords: '_armenian_' },
              armenian_stemmer: { type: 'stemmer', language: 'armenian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'armenian_stemmer']
            }
          ),
          new(
            name: :basque,
            short_name: :eu,
            filter: {
              basque_stop: { type: 'stop', stopwords: '_basque_' },
              basque_stemmer: { type: 'stemmer', language: 'basque' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'basque_stemmer']
            }
          ),
          new(
            name: :brazilian,
            short_name: :bg,
            filter: {
              brazilian_stop: { type: 'stop', stopwords: '_brazilian_' },
              brazilian_stemmer: { type: 'stemmer', language: 'brazilian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'brazilian_stemmer']
            }
          ),
          new(
            name: :catalan,
            short_name: :ca,
            filter: {
              catalan_elision: { type: 'elision', 'articles':   [ 'd', 'l', 'm', 'n', 's', 't'] },
              catalan_stop: { type: 'stop', stopwords: '_catalan_' },
              catalan_stemmer: { type: 'stemmer', language: 'catalan' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['catalan_elision', 'lowercase', 'catalan_stemmer']
            }
          ),
          new(
            name: :czech,
            short_name: :cs,
            filter: {
              czech_stop: { type: 'stop', stopwords: '_czech_' },
              czech_stemmer: { type: 'stemmer', language: 'czech' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'czech_stemmer']
            }
          ),
          new(
            name: :danish,
            short_name: :da,
            filter: {
              danish_stop: { type: 'stop', stopwords: '_danish_' },
              danish_stemmer: { type: 'stemmer', language: 'danish' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'danish_stemmer']
            }
          ),
          new(
            name: :dutch,
            short_name: :nl,
            filter: {
              dutch_stop: { type: 'stop', stopwords: '_dutch_' },
              dutch_stemmer: { type: 'stemmer', language: 'dutch' },
              dutch_override: { type: 'stemmer_override', 'rules': [ 'fiets=>fiets', 'bromfiets=>bromfiets', 'ei=>eier', 'kind=>kinder' ] }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'dutch_override', 'dutch_stemmer']
            }
          ),
          new(
            name: :english,
            short_name: :en,
            filter: {
              english_stop: { type: 'stop', stopwords: '_english_' },
              english_stemmer: { type: 'stemmer', language: 'english' },
              english_possessive_stemmer: { type: 'stemmer', language: 'possessive_english' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['english_possessive_stemmer', 'lowercase', 'english_stemmer']
            }
          ),
          new(
            name: :finnish,
            short_name: :fi,
            filter: {
              finnish_stop: { type: 'stop', stopwords: '_finnish_' },
              finnish_stemmer: { type: 'stemmer', language: 'finnish' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'finnish_stemmer']
            }
          ),
          new(
            name: :french,
            short_name: :fr,
            filter: {
              french_elision: { type: 'elision', 'articles_case': true, 'articles': [ 'l', 'm', 't', 'qu', 'n', 's', 'j', 'd', 'c', 'jusqu', 'quoiqu', 'lorsqu', 'puisqu' ] },
              french_stop: { type: 'stop', stopwords: '_french_' },
              french_stemmer: { type: 'stemmer', language: 'light_french' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['french_elision', 'lowercase', 'french_stemmer']
            }
          ),
          new(
            name: :galician,
            short_name: :gl,
            filter: {
              galician_stop: { type: 'stop', stopwords: '_galician_' },
              galician_stemmer: { type: 'stemmer', language: 'galician' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'galician_stemmer']
            }
          ),
          new(
            name: :german,
            short_name: :de,
            filter: {
              german_stop: { type: 'stop', stopwords: '_german_' },
              german_stemmer: { type: 'stemmer', language: 'light_german' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'german_normalization', 'german_stemmer']
            }
          ),
          new(
            name: :greek,
            short_name: :el,
            filter: {
              greek_stop: { type: 'stop', stopwords: '_greek_' },
              greek_lowercase: { type: 'lowercase', language: 'greek' },
              greek_stemmer: { type: 'stemmer', language: 'greek' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['greek_lowercase', 'greek_stemmer']
            }
          ),
          new(
            name: :hindi,
            short_name: :hi,
            filter: {
              hindi_stop: { type: 'stop', stopwords: '_hindi_' },
              hindi_stemmer: { type: 'stemmer', language: 'hindi' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'indic_normalization', 'hindi_normalization', 'hindi_stemmer']
            }
          ),
          new(
            name: :hungarian,
            short_name: :hu,
            filter: {
              hungarian_stop: { type: 'stop', stopwords: '_hungarian_' },
              hungarian_stemmer: { type: 'stemmer', language: 'hungarian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'hungarian_stemmer']
            }
          ),
          new(
            name: :indonesian,
            short_name: :id,
            filter: {
              indonesian_stop: { type: 'stop', stopwords: '_indonesian_' },
              indonesian_stemmer: { type: 'stemmer', language: 'indonesian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'indonesian_stemmer']
            }
          ),
          new(
            name: :irish,
            short_name: :ga,
            filter: {
              irish_elision: { type: 'elision', 'articles': [ 'h', 'n', 't' ] },
              irish_stop: { type: 'stop', stopwords: '_irish_' },
              irish_lowercase: { type: 'lowercase', language: 'irish' },
              irish_stemmer: { type: 'stemmer', language: 'irish' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['irish_elision', 'irish_lowercase', 'irish_stemmer']
            }
          ),
          new(
            name: :italian,
            short_name: :it,
            filter: {
              italian_elision: { type: 'elision', 'articles': [ 'c', 'l', 'all', 'dall', 'dell', 'nell', 'sull', 'coll', 'pell', 'gl', 'agl', 'dagl', 'degl', 'negl', 'sugl', 'un', 'm', 't', 's', 'v', 'd' ] },
              italian_stop: { type: 'stop', stopwords: '_italian_' },
              italian_stemmer: { type: 'stemmer', language: 'light_italian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['italian_elision', 'lowercase', 'italian_stemmer']
            }
          ),
          new(
            name: :latvian,
            short_name: :lv,
            filter: {
              latvian_stop: { type: 'stop', stopwords: '_latvian_' },
              latvian_stemmer: { type: 'stemmer', language: 'latvian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'latvian_stemmer']
            }
          ),
          new(
            name: :lithuanian,
            short_name: :lt,
            filter: {
              lithuanian_stop: { type: 'stop', stopwords: '_lithuanian_' },
              lithuanian_stemmer: { type: 'stemmer', language: 'lithuanian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'lithuanian_stemmer']
            }
          ),
          new(
            name: :norwegian,
            short_name: :no,
            filter: {
              norwegian_stop: { type: 'stop', stopwords: '_norwegian_' },
              norwegian_stemmer: { type: 'stemmer', language: 'norwegian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'norwegian_stemmer']
            }
          ),
          new(
            name: :portuguese,
            short_name: :pt,
            filter: {
              portuguese_stop: { type: 'stop', stopwords: '_portuguese_' },
              portuguese_stemmer: { type: 'stemmer', language: 'light_portuguese' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'portuguese_stemmer']
            }
          ),
          new(
            name: :romanian,
            short_name: :ro,
            filter: {
              romanian_stop: { type: 'stop', stopwords: '_romanian_' },
              romanian_stemmer: { type: 'stemmer', language: 'romanian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'romanian_stemmer']
            }
          ),
          new(
            name: :russian,
            short_name: :ru,
            filter: {
              russian_stop: { type: 'stop', stopwords: '_russian_' },
              russian_stemmer: { type: 'stemmer', language: 'russian' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'russian_stemmer']
            }
          ),
          new(
            name: :spanish,
            short_name: :es,
            filter: {
              spanish_stop: { type: 'stop', stopwords: '_spanish_' },
              spanish_stemmer: { type: 'stemmer', language: 'light_spanish' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'spanish_stemmer']
            }
          ),
          new(
            name: :swedish,
            short_name: :sv,
            filter: {
              swedish_stop: { type: 'stop', stopwords: '_swedish_' },
              swedish_stemmer: { type: 'stemmer', language: 'swedish' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['lowercase', 'swedish_stemmer']
            }
          ),
          new(
            name: :turkish,
            short_name: :tr,
            filter: {
              turkish_stop: { type: 'stop', stopwords: '_turkish_' },
              turkish_lowercase: { type: 'lowercase', language: 'turkish' },
              turkish_stemmer: { type: 'stemmer', language: 'turkish' }
            },
            analyzer: {
              tokenizer: 'standard',
              filter: ['apostrophe', 'turkish_lowercase', 'turkish_stemmer']
            }
          ),
          new(
            name: :thai,
            short_name: :th,
            filter: {
              thai_stop: { type: 'stop', stopwords: '_thai_' }
            },
            analyzer: {
              tokenizer: 'thai',
              filter: ['lowercase', 'thai_stop']
            }
          ),
        ].freeze
      end
    end
  end
end
