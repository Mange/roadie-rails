require 'rails'

module Roadie
  module Rails
    class Railtie < ::Rails::Railtie
      config.roadie = Roadie::Rails::Options.new

      initializer "roadie-rails.setup" do |app|
        config.roadie.asset_providers = [
          Roadie::FilesystemProvider.new(::Rails.root.join("public").to_s),
        ]

        # Saying config.assets.enabled here does not work in Rails 3.1-3.2, but
        # APP.config.assets work. There is a difference between "config" and
        # "app.config" on those versions.
        if app.config.respond_to?(:assets) && app.config.assets.enabled != false
          if app.assets
            config.roadie.asset_providers << AssetPipelineProvider.new(app.assets)
          else
            app.config.assets.configure do |env|
              config.roadie.asset_providers << AssetPipelineProvider.new(env)
            end
          end
        end
      end
    end
  end
end
