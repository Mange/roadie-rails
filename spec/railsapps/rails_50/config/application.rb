require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails50
  class Application < Rails::Application
    config.roadie.url_options = { host: 'example.app.org' }
  end
end
