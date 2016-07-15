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
      Dir[File.join(Mes::Elastic::ROOT, 'app/models/mes/*.rb')].map do |file|
        "::Mes::Elastic::#{File.basename(file, '.rb').classify}".constantize
      end
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
      Dir[File.join(Mes::Elastic::ROOT, 'app/models/mes/*.rb')].map do |file|
        "::Eva::Elastic::#{File.basename(file, '.rb').classify}".constantize
      end
    end
  end
end
