# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "moxy/version"

Gem::Specification.new do |s|
  s.name        = "moxy"
  s.version     = Moxy::VERSION
  s.authors     = ["Dotan Nahum"]
  s.email       = ["jondotan@gmail.com"]
  s.homepage    = "https://github.com/jondot/moxy"
  s.summary     = %q{Moxy is a mock (programmable) proxy}
  s.description = %q{Moxy is a mock (programmable) proxy}

  s.rubyforge_project = "moxy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_dependency "sinatra", '1.3.2'
  s.add_dependency "sinatra-flash", '0.3.0'
  s.add_dependency "fakefs", '0.4.0'
  s.add_dependency "webmock", '1.7.10'


  s.add_development_dependency "rack-test"
  s.add_development_dependency "rr"
  s.add_development_dependency "watchr"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-html"

end
