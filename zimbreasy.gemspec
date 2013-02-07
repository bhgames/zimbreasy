# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zimbreasy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jordan Prince"]
  gem.email         = ["jordanmprince@gmail.com"]
  gem.description   = %q{A no-nonsense gem for the nonsensical Zimbra API.}
  gem.summary       = %q{A no-nonsense gem for the nonsensical Zimbra API.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "zimbreasy"
  gem.require_paths = ["lib"]
  gem.version       = Zimbreasy::VERSION

  gem.add_dependency 'test-unit'
  gem.add_dependency 'savon', '~> 1.1.0'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'icalendar'
end
