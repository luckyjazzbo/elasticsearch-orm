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
    end
  end
end
