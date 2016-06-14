require 'mes/elastic/version'
require 'mes/elastic/model'

MODELS_PATH = File.expand_path('../../app/models', __FILE__)

module Mes
  module Elastic
    Dir[File.join(MODELS_PATH, 'mes/*.rb')].each do |file|
      model_class = File.basename(file, '.rb').classify
      autoload model_class, file
    end
  end
end

module Eva
  module Elastic
    Dir[File.join(MODELS_PATH, 'eva/*.rb')].each do |file|
      model_class = File.basename(file, '.rb').classify
      autoload model_class, file
    end
  end
end
