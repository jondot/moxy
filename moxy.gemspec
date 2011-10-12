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
  s.add_dependency "sinatra"
  s.add_dependency "fakefs"
  s.add_dependency "webmock"


  s.add_development_dependency "sinatra-reloader"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rr"
  s.add_development_dependency "watchr"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-html"

end
