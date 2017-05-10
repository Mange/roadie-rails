require "rspec/collection_matchers"

if ENV['CI'] &&
    RUBY_ENGINE != 'rbx' # coverage is extremely slow on Rubinius
  require 'simplecov'
  SimpleCov.start

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'roadie-rails'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
end

Dir['./spec/support/**/*.rb'].each { |file| require file }
