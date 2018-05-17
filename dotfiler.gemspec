
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dotfiler/version"

Gem::Specification.new do |spec|
  spec.name          = "dotfiler"
  spec.version       = Dotfiler::VERSION
  spec.authors       = ["Aleksandar Radunovic"]
  spec.email         = ["aleksandar@radunovic.io"]

  spec.summary       = "pending"
  spec.description   = "pending"
  spec.homepage      = "https://pending.com"
  spec.license       = "MIT"

  spec.files        = Dir["README.md", "LICENSE.txt", "lib/**/*.rb", "dotfiler.gemspec"]
  spec.require_path = "lib"
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_dependency "dry-container"
  spec.add_dependency "dry-auto_inject"
  spec.add_dependency "hanami-cli"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
