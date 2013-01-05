# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chrome-app-engine-rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "chrome-app-engine-rails"
  s.version     = ChromeAppEngineRails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Yann Hourdel"]
  s.email       = ["github@hourdel.fr"]
  s.homepage    = "https://github.com/yhourdel/chrome-app-engine-rails"
  s.summary     = "Rails 3 engine for building Google Chrome and Chromium apps"
  s.description = "This gem provides a Rails 3 engine for building Google Chrome and Chromium apps."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'listen'

end
