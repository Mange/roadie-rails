require "rspec/collection_matchers"

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

require 'roadie-rails'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
end

Dir['./spec/support/**/*.rb'].each { |file| require file }
