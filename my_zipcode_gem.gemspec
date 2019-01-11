# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "generators/my_zipcode_gem/version"

Gem::Specification.new do |s|
  s.name        = "my_zipcode_gem"
  s.version     = MyZipcodeGem::VERSION

  def travis?
    ENV['TRAVIS']
  end

  def master_branch?
    ENV['TRAVIS_BRANCH'] == 'master'
  end

  def tag?
    ENV['TRAVIS_TAG']
  end

  if travis? && !master_branch? && !tag?
    s.version     = "#{s.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}"
  end

  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Blackburn", "Chris McKnight"]
  s.email       = ["chris [at] midwiretech [dot] com", "cmckni3 [at] gmail [dot] com"]
  s.homepage    = "https://github.com/midwire/my_zipcode_gem"
  s.summary     = %q{A Ruby gem to handle all things zipcode.}
  s.description = %q{A Ruby gem for looking up and manipulating US postal codes and geocodes.}
  s.licenses    = ['MIT']

  s.rubyforge_project = "my_zipcode_gem"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rails', '>= 3.0.0')
  s.add_dependency('memoist', '~> 0.16.0')
end
