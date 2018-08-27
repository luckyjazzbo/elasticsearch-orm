# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch-orm/version'

Gem::Specification.new do |spec|
  spec.name          = 'elasticsearch-orm'
  spec.version       = ElasticsearchOrm::VERSION
  spec.authors       = ['Anton Priadko', 'Roman Lupiichuk']
  spec.email         = ['antonpriadko@gmail.com', 'roman.lupiychuk@gmail.com']

  spec.summary       = 'Gem with reusable logics related to ElasticSearch'
  spec.description   =
    'This gem aggregates ElasticSearch logics, which can be reused in glomex applications'
  spec.homepage      = 'https://github.com/glomex/elasticsearch-orm'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ''
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         =
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday_middleware-aws-signers-v4'
  spec.add_dependency 'activesupport', '~> 5.0', '>= 5.0.0.1'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'elasticsearch', '~> 5.0.0'
end
