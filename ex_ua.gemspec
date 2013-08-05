# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ex_ua/version"

Gem::Specification.new do |s|
  s.name        = "ex_ua"
  s.version     = ExUa::VERSION
  s.authors     = ["Andriy Dmytrenko"]
  s.email       = ["refresh.xss@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{An http://ex.ua/ API}
  s.description = %q{Ruby API for ex.ua}

  s.rubyforge_project = "ex_ua"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec", '>= 2.10.0'
  s.add_development_dependency "rake"
  s.add_runtime_dependency "httparty", '>= 0.10.0'
  s.add_runtime_dependency "nokogiri", '>= 1.5.0'
end
