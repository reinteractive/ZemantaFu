# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "zemanta_fu"
  s.version     = ZemantaFu::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Wiseley"]
  s.email       = ["wiseleyb@gmail.com"]
  s.homepage    = "https://github.com/reInteractive/ZemantaFu"
  s.date        = Date.today.to_s
  s.summary     = "WIP - gem for zemanta http://www.zemanta.com/"
  s.description = "WIP - gem for zemanta http://www.zemanta.com/"
  s.files       = `git ls-files`.split("\n") - %w[zemanta_fu.gemspec Gemfile init.rb]
  s.require_paths = ["lib"]
  # s.add_runtime_dependency "httparty"
  # s.add_development_dependency "rspec"
  # s.add_development_dependency "webmock"
  # s.add_development_dependency "json"
end
