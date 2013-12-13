# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'params_sanitizer/version'

Gem::Specification.new do |spec|
  spec.name          = "params_sanitizer"
  spec.version       = ParamsSanitizer::VERSION
  spec.authors       = ["alfa-jpn"]
  spec.email         = ["a.nkmr.ja@gmail.com"]
  spec.description   = "params_sanitizer sanitize parameter.It is really easy and useful."
  spec.summary       = "params_sanitizer sanitize parameter.It is really easy and useful."
  spec.homepage      = "https://github.com/alfa-jpn/params_sanitizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"

  spec.add_dependency "actionpack", "~> 4.0"
end
