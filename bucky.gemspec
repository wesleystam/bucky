# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bucky/version'

Gem::Specification.new do |spec|
  spec.name          = "bucky"
  spec.version       = Bucky::VERSION
  spec.authors       = ["Sander Kuijper"]
  spec.email         = ["sajoku@me.com"]

  spec.summary       = %q{Buckaroo payment gem}
  spec.description   = %q{Buckaroo payment gem for the NVP gateway}
  spec.homepage      = "http://github.com/sajoku/bucky"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "rails"
  spec.add_runtime_dependency "addressable"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"
end
