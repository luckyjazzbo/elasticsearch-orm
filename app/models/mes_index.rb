require 'mes/elastic/model'

module Mes
  class MesIndex < Elastic::Model
    set_index 'lte', url: ENV['MES_ELASTICSEARCH_URL']
  end
end
