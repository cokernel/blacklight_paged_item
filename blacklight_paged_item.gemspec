# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), "lib/blacklight_paged_item/version")

Gem::Specification.new do |s|
  s.name          = "blacklight_paged_item"
  s.version       = BlacklightPagedItem::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Michael Slone"]
  s.email         = ["m.slone@gmail.com"]
  s.homepage      = "https://github.com/cokernel/blacklight_paged_item"
  s.summary       = "Add internal item pagination to Blacklight."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.license       = "Apache 2.0"

  s.add_dependency "blacklight", ">= 5.7", "< 6.0"
  s.add_dependency "rails", "~> 4.1"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end
