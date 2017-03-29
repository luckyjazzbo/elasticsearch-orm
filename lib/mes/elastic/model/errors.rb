module Mes
  module Elastic
    class Model
      class ElasticError                          < StandardError; end
      class InvalidActionError                    < ElasticError; end
      class UnpermittedAttributeError             < ElasticError; end
      class UnpermittedFieldNameError             < ElasticError; end
      class RecordNotFoundError                   < ElasticError; end
      class SettingFieldsForModelWithoutTypeError < ElasticError; end
      class UnknownTypeError                      < ElasticError; end
      class IntatiatingModelWithoutTypeError      < ElasticError; end
      class UnknownError                          < ElasticError; end

      def self.with_error_convertion
        yield
      rescue Elasticsearch::Transport::Transport::Error => e
        raise original2lib_error(e)
      end

      def self.original2lib_error(e)
        case e
        when Elasticsearch::Transport::Transport::Errors::NotFound
          RecordNotFoundError.new("#{e.class.name} - #{e.message}")
        else
          UnknownError.new("#{e.class.name} - #{e.message}")
        end
      end
    end
  end
end
