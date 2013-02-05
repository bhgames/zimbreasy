# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zimbreasy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jordan Prince"]
  gem.email         = ["jordanmprince@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "zimbreasy"
  gem.require_paths = ["lib"]
  gem.version       = Zimbreasy::VERSION
  gem.add_dependency 'rest_client'
  gem.add_dependency 'cgi'
  gem.add_dependency 'json'
  gem.add_dependency 'icalendar'
  gem.add_dependency 'date'
end
