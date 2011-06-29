# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "generators/my_zipcode_gem/version"

Gem::Specification.new do |s|
  s.name        = "my_zipcode_gem"
  s.version     = MyZipcodeGem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Blackburn"]
  s.email       = ["chris [at] midwiretech [dot] com"]
  s.homepage    = "https://github.com/midwire/my_zipcode_gem"
  s.summary     = %q{A Ruby gem to handle all things zipcode.}
  s.description = %q{A Ruby gem for looking up and manipulating US postal codes and geocodes.}

  s.rubyforge_project = "my_zipcode_gem"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rails', '>= 3.0.0')
  s.add_dependency('rubigen', '1.5.6')
  s.add_dependency('fastercsv')

  s.add_development_dependency('sqlite3-ruby')
  s.add_development_dependency('shoulda', '2.11.3')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-rails')
  s.add_development_dependency('cucumber')
  s.add_development_dependency('cucumber-rails')
end
