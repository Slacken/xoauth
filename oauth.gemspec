# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth'

Gem::Specification.new do |spec|
  spec.name          = "xoauth"
  spec.version       = Oauth::VERSION
  spec.authors       = ["binz"]
  spec.email         = ["xinkiang@gmail.com"]
  spec.summary       = %q{Chinese Social Network Oauth2.0 Implemetation.}
  spec.description   = %q{Chinese Social Network Oauth2.0 Implemetation.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "mongoid"
end
