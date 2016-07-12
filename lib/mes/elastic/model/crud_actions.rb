require 'elasticsearch'

module Mes
  module Elastic
    class Model
      module CRUDActions
        def initialize_save_actions(opts = {})
          @persisted = opts[:persisted] || false
        end

        def save
          assign_attribute(:id, self.class.save(attributes))
          persist!
        end

        # INFO: alias `save!` for now as it is used by FactoryGirl
        alias_method :save!, :save

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

      module CRUDActionsClassMethods
        def upsert(attrs = {})
          new(attrs).tap(&:save)
        end
      end
    end
  end
end
