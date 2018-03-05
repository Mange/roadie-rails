require_relative 'boot'

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsMaster
  class Application < Rails::Application
    config.roadie.url_options = { host: 'example.app.org' }
  end
end
