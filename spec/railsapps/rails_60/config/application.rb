require_relative "boot"

require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Rails60
  class Application < Rails::Application
    config.load_defaults 6.0
    config.roadie.url_options = {host: "example.app.org"}
  end
end
