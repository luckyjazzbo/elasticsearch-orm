module Eva
  module Elastic
    class Resource < ::Mes::Elastic::Model
      config(
        url: ENV['EVA_ELASTICSEARCH_URL'],
        index: 'lte',
        index_settings: {
          analysis: {
            filter: {
              autocomplete_filter: {
                type: 'edge_ngram',
                min_gram: 1,
                max_gram: 20
              }
            },
            analyzer: {
              autocomplete: {
                type: 'custom',
                tokenizer: 'standard',
                filter: ['lowercase', 'autocomplete_filter']
              }
            }
          }
        }
      )
      multitype
    end
  end
end

Dir[File.expand_path('../*.rb', __FILE__)].each { |file| require_relative file }
