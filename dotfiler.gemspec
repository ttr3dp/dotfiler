require File.expand_path("../lib/dotfiler/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name         = "dotfiler"
  spec.version      = Dotfiler::VERSION
  spec.authors      = ["Aleksandar Radunovic"]
  spec.email        = ["aleksandar@radunovic.io"]

  spec.summary      = "CLI gem for managing dotfiles"
  spec.description  = spec.summary
  spec.homepage     = "https://github.com/aradunovic/dotfiler"
  spec.license      = "MIT"

  spec.files        = Dir["README.md", "LICENSE.txt", "lib/**/*.rb", "dotfiler.gemspec"]
  spec.require_path = "lib"
  spec.bindir       = "exe"
  spec.executables  = ["dotfiler"]

  gem.required_ruby_version = ">= 2.1"

  spec.add_dependency "dry-container",   "0.6.0"
  spec.add_dependency "dry-auto_inject", "0.4.6"
  spec.add_dependency "hanami-cli",      "0.2.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "rspec",   "~> 3.0"
end
