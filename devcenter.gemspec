# -*- encoding: utf-8 -*-
require File.expand_path('../lib/devcenter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Continanza"]
  gem.email         = ["csquared@heroku.com"]
  gem.description   = %q{Compile and push articles to Heroku Dev Center.}
  gem.summary       = %q{Compile and push articles to Heroku Dev Center.}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "devcenter"
  gem.require_paths = ["lib"]
  gem.version       = Devcenter::VERSION

  gem.add_dependency 'rest-client'
  gem.add_dependency 'configliere'
  gem.add_dependency 'nokogiri'
  gem.add_development_dependency 'fakefs'
end
