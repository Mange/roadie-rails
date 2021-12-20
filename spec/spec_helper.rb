# frozen_string_literal: true

require "rspec/collection_matchers"

if ENV["CI"]
  require "simplecov"
  SimpleCov.start do
    # Only cover lib/. Omit spec/railsapps.
    add_filter do |src|
      src.filename !~ %r{/lib/roadie/rails}
    end
  end

  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

require "roadie-rails"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
end

Dir["./spec/support/**/*.rb"].sort.each { |file| require file }
