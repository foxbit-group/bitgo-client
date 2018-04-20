# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "bitgo_client/version"

Gem::Specification.new do |spec|
  spec.name          = "bitgo-client"
  spec.version       = BitgoClient::VERSION
  spec.authors       = ["Bruno Soares"]
  spec.email         = ["bruno@bsoares.com"]

  spec.summary     = "BitGo's API Client."
  spec.description = "A Ruby client to BitGo's API and Express API."
  spec.homepage    = "https://bitbucket.org/modiaxtech/bitgo-client"
  spec.license     = "MIT"

  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "typhoeus", "~> 1.3"

  spec.add_development_dependency "bundler",                   "~> 1.16"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"
  spec.add_development_dependency "pry-byebug",                "~> 3.6"
  spec.add_development_dependency "rake",                      "~> 10.0"
  spec.add_development_dependency "rspec",                     "~> 3.0"
  spec.add_development_dependency "rubocop",                   "~> 0.53"
  spec.add_development_dependency "rubocop-github",            "~> 0.10"
  spec.add_development_dependency "rubocop-rspec",             "~> 1.24"
  spec.add_development_dependency "simplecov",                 "~> 0.16"
  spec.add_development_dependency "simplecov-console",         "~> 0.4"
end
