require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

module Rails41
  class Application < Rails::Application
    config.roadie.url_options = {host: 'example.app.org'}
  end
end
