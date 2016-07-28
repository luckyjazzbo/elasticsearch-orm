require File.join(Mes::Elastic::ROOT, 'spec/support/elastic_index_helpers')
require File.join(Mes::Elastic::ROOT, 'spec/support/with_eva_indices')
require File.join(Mes::Elastic::ROOT, 'spec/support/with_mes_indices')

require 'factory_girl'
Dir[File.join(Mes::Elastic::ROOT, 'spec/factories/**/*.rb')].each { |file| require(file) }