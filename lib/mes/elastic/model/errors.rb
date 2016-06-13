module Mes
  module Elastic
    class Model
      class UnpermittedAttributeException             < StandardError; end
      class UnpermittedFieldNameException             < StandardError; end
      class RecordNotFoundException                   < StandardError; end
      class SettingFieldsForModelWithoutTypeException < StandardError; end
      class UnknownTypeException                      < StandardError; end
      class IntatiatingModelWithoutType               < StandardError; end
    end
  end
end
