require 'mes/elastic/version'
require 'mes/elastic/utils'
require 'mes/elastic/model'

module Mes
  module Elastic
    ROOT = File.expand_path('../..', __FILE__).freeze

    def self.load_models
      Dir[File.join(Mes::Elastic::ROOT, 'app/models/**/*.rb')].sort.map(&method(:require))
    end
  end

  autoload :Analyzers, File.join(Elastic::ROOT, 'app/models/mes/analyzers')
  autoload :Video, File.join(Elastic::ROOT, 'app/models/mes/video')
  autoload :Taxonomy, File.join(Elastic::ROOT, 'app/models/mes/taxonomy')
end
