require 'elasticsearch'

module Mes
  module Elastic
    class Model
      module SaveActions
        def initialize_save_actions
          @persisted = false
        end

        def save
          assign_attribute(:id, self.class.save(attributes))
          persist!
        end

        def update_attributes(attrs = {})
          assign_attributes(attrs)
          save
        end

        def persist!
          @persisted = true
        end

        def new_record?
          !persisted?
        end

        def persisted?
          @persisted
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
