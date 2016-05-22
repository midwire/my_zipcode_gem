# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "generators/my_zipcode_gem/version"

Gem::Specification.new do |s|
  s.name        = "us_zipcode"
  s.version     = UsZipcode::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chakreshwar"]
  s.email       = ["chakreshwar.sharma@yahoo.com"]
  s.homepage    = "https://github.com/ChakreshwarSharma/us_zipcode"
  s.summary     = %q{A Ruby gem to handle all things zipcode.}
  s.description = %q{A Ruby gem for looking up and manipulating US postal codes and geocodes.}
  s.licenses    = ['MIT']

  s.rubyforge_project = "us_zipcode"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rails', '>= 3.0.0')
  s.add_dependency('memoist', '~> 0.11.0')
end
