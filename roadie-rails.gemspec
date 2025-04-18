# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "roadie/rails/version"

Gem::Specification.new do |spec|
  spec.name = "roadie-rails"
  spec.version = Roadie::Rails::VERSION
  spec.authors = ["Magnus Bergmark"]
  spec.email = ["magnus.bergmark@gmail.com"]
  spec.homepage = "https://github.com/Mange/roadie-rails"
  spec.summary = "Making HTML emails comfortable for the Rails rockstars"
  spec.description = "Hooks Roadie into your Rails application to help with email generation."
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.files = `git ls-files | grep -v ^spec`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.extra_rdoc_files = %w[README.md Changelog.md LICENSE.txt]
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 5.1", "< 8.1"
  spec.add_dependency "roadie", "~> 5.0"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rails", ">= 5.1", "< 8.1"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "ostruct"

  spec.post_install_message = "This would be the last version that supports ruby 2.7"
end
