# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'phil/version'

Gem::Specification.new do |s|
  s.name = "phil"
  s.version = Phil::VERSION
  s.license = "MIT"

  s.authors = ["Cameron Daigle"]
  s.email = ["cameron@hashrocket.com"]
  s.description = "Phil is a collection of markup generation and iteration methods to ease creation of UI mockups. It uses Faker for standard content generation and adds a number of convenience methods and ways to build consistently varied markup for layout testing."

  s.homepage = "https://github.com/camerond/phil"
  s.require_paths = ["lib"]
  s.summary = "Quickly and easily generate varied markup and content."

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency("ffaker", ">=2.0.0")
  s.add_dependency("activesupport")
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
  s.add_development_dependency("ox")

  s.files = Dir.glob("lib/**/*") + %w(LICENSE README.md Rakefile)
  s.require_path = 'lib'
end
