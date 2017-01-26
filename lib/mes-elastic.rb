require 'mes/elastic/version'
require 'mes/elastic/model'

module Mes
  module Elastic
    ROOT = File.expand_path('../..', __FILE__).freeze
  end
end

module Mes
  module Elastic
    Dir[File.join(Mes::Elastic::ROOT, 'app/models/mes/*.rb')].each do |file|
      model_class = File.basename(file, '.rb').classify
      autoload model_class, file
    end

    def self.models
      (base_model_names + app_model_names).map do |file|
        "::Mes::Elastic::#{File.basename(file, '.rb').classify}".constantize
      end
    end

    def self.app_model_names
      return [] unless defined?(App) && App.respond_to?(:root)
      Dir[File.join(App.root, 'app/models/mes/*.rb')]
    end

    def self.base_model_names
      Dir[File.join(Mes::Elastic::ROOT, 'app/models/mes/*.rb')]
    end
  end
end

module Eva
  module Elastic
    Dir[File.join(Mes::Elastic::ROOT, 'app/models/eva/*.rb')].each do |file|
      model_class = File.basename(file, '.rb').classify
      autoload model_class, file
    end

    def self.models
      (base_model_names + app_model_names).map do |file|
        "::Eva::Elastic::#{File.basename(file, '.rb').classify}".constantize
      end
    end

    def self.app_model_names
      return [] unless defined?(App) && App.respond_to?(:root)
      Dir[File.join(App.root, 'app/models/eva/*.rb')]
    end

    def self.base_model_names
      Dir[File.join(Mes::Elastic::ROOT, 'app/models/eva/*.rb')]
    end
  end
end
