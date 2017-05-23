# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'fluent-plugin-gcloud-metadata'
  s.version       = '1.0.0'
  s.authors       = ['engerim']
  s.email         = ['alexander.miehe@tourstream.eu']
  s.description   = %q{gcloud metadata filter plugin for Fluent. The Plugin adds gcloud metadata to the record }
  s.summary       = s.description
  s.homepage      = 'https://github.com/tourstream/fluent-plugin-gcloud-metadata'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)

  s.add_runtime_dependency 'fluentd', '~> 0.14'

  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'webmock', '~> 2.3'
  s.add_development_dependency 'test-unit', '~> 3.1'
  s.add_development_dependency 'minitest', '~> 5.8'
  s.add_development_dependency 'vcr', '~> 3.0'
end