# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prismic_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "prismic_rails"
  spec.version       = PrismicRails::VERSION
  spec.authors       = ["Felix Langenegger"]
  spec.email         = ["f.langenegger@fadendaten.ch"]

  spec.summary       = %q{PrismicRails provides rails view helpers to query prismic.io.}
  spec.description   = %q{With PrismicRails it is simple to query the prismic.io API for a defined custom type. By providing rails helpers the integration in your rails view is much easier as before.}
  spec.homepage      = "https://github.com/fadendaten/prismic_rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "prismic.io", "~> 1.5", ">= 1.5"
  spec.add_runtime_dependency "rails", ">= 4.2"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "rdoc", "~> 5.1", ">= 5.1"
  spec.add_development_dependency "vcr", "~> 3.0.3", ">= 3.0.3"
  spec.add_development_dependency "dotenv", "~> 2.2", ">= 2.2.1"
  spec.add_development_dependency "webmock", "~> 3.0", ">= 3.0.1"
  spec.add_development_dependency 'simplecov', "~> 0.14", ">= 0.14.1"
  spec.add_development_dependency 'pry', '~> 0.10.4'
end
