# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'halo-reach-api-version'

Gem::Specification.new do |s|
  s.name        = "halo-reach-api"
  s.version     = Halo::Reach::API::VERSION.dup
  s.authors     = ["David Czarnecki"]
  s.email       = ["dczarnecki@agoragames.com"]
  s.homepage    = "https://github.com/agoragames/halo-reach-api"
  s.summary     = %q{Ruby gem for interacting with the Halo:Reach API}
  s.description = %q{Ruby gem for interacting with the Halo:Reach API}

  s.rubyforge_project = "halo-reach-api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('httparty')
  s.add_dependency('json')

  s.add_development_dependency('rake')  
  s.add_development_dependency('fakeweb')
  s.add_development_dependency('mocha')
end
