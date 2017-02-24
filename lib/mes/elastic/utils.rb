module Mes
  module Elastic
    module Utils
      def self.app_root
        @app_root ||=
          if defined?(App) && App.respond_to?(:root)
            App.root.to_s
          elsif defined?(Rails)
            Rails.root.to_s
          elsif defined?(Padrino)
            Padrino.root.to_s
          end
      end
    end
  end
end
