# -*- encoding: utf-8 -*-
require File.expand_path('../lib/swim/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jerry Richardson"]
  gem.email         = ["jerry@disruptiveventures.com"]
  gem.description   = %q{Sync or Swim}
  gem.summary       = %q{Synchronize ActiveRecord Objects Across Environments with JSON and git}
  gem.homepage      = "http://disruptive.github.com/swim"

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'sqlite3'
  gem.add_dependency 'multi_json' unless RUBY_VERSION >= "1.9.3"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "swim"
  gem.require_paths = ["lib"]
  gem.version       = Swim::VERSION
end
