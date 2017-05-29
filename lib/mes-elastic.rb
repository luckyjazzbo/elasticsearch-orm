require 'mes/elastic/version'
require 'mes/elastic/utils'
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
        "::Mes::#{File.basename(file, '.rb').classify}".safe_constantize ||
          "::Mes::Elastic::#{File.basename(file, '.rb').classify}".constantize
      end
    end

    def self.app_model_names
      return [] if Mes::Elastic::Utils.app_root.blank?
      Dir[File.join(Mes::Elastic::Utils.app_root, 'app/models/mes/*.rb')]
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
        "::Eva::#{File.basename(file, '.rb').classify}".safe_constantize ||
          "::Eva::Elastic::#{File.basename(file, '.rb').classify}".constantize
      end
    end

    def self.app_model_names
      return [] if Mes::Elastic::Utils.app_root.blank?
      Dir[File.join(Mes::Elastic::Utils.app_root, 'app/models/eva/*.rb')]
    end

    def self.base_model_names
      Dir[File.join(Mes::Elastic::ROOT, 'app/models/eva/*.rb')]
    end
  end
end

module ContentApi
  module Elastic
    Dir[File.join(Mes::Elastic::ROOT, 'app/models/content_api/*.rb')].each do |file|
      model_class = File.basename(file, '.rb').classify
      autoload model_class, file
    end

    def self.models
      (base_model_names + app_model_names).map do |file|
        "::ContentApi::#{File.basename(file, '.rb').classify}".safe_constantize ||
          "::ContentApi::Elastic::#{File.basename(file, '.rb').classify}".constantize
      end
    end

    def self.app_model_names
      return [] if Mes::Elastic::Utils.app_root.blank?
      Dir[File.join(Mes::Elastic::Utils.app_root, 'app/models/content_api/*.rb')]
    end

    def self.base_model_names
      Dir[File.join(Mes::Elastic::ROOT, 'app/models/content_api/*.rb')]
    end
  end
end
