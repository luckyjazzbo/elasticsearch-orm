require 'elasticsearch'

module Mes
  module Elastic
    class Model
      module SaveActions
        def save
          assign_attribute(:id, self.class.save(attributes))
          persist!
        end

        def update(attrs = {})
          assign_attributes(attrs)
          save
        end

        def persist!
          @persisted = true
        end

        def new_record?
          !@persisted
        end

        def persisted?
          !new_record?
        end
      end

      module SaveActionsClassMethods
        def upsert(attrs = {})
          new(attrs).tap(&:save)
        end
      end
    end
  end
end
