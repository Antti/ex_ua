# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ex_ua/version"

Gem::Specification.new do |s|
  s.name        = "ex_ua"
  s.version     = ExUa::VERSION
  s.authors     = ["Andriy Dmytrenko"]
  s.email       = ["refresh.xss@gmail.com"]
  s.homepage    = "https://github.com/Antti/ex_ua"
  s.summary     = %q{An http://ex.ua/ API}
  s.description = %q{Ruby API for ex.ua}

  s.files         = `git ls-files | grep -v spec/cassettes`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* | grep -v spec/cassettes`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.license = 'MIT'

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec", '>= 2.10.0'
  s.add_development_dependency "rake", '>= 0.9.0'
  s.add_development_dependency "vcr", '>= 2.5.0'
  s.add_development_dependency "webmock", '>= 1.9.0'
  s.add_runtime_dependency "httparty", '>= 0.10.0'
  s.add_runtime_dependency "nokogiri", '>= 1.5.0'
  s.add_runtime_dependency "addressable", '>= 2.3.0'
end
