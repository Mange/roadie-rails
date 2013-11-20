require 'rails'

module Roadie
  module Rails
    class Railtie < ::Rails::Railtie
      config.roadie = Roadie::Rails::Options.new

      initializer "roadie-rails.setup" do |app|
        config.roadie.asset_providers = [
          Roadie::FilesystemProvider.new(::Rails.root.join("public").to_s),
        ]
      end
    end
  end
end
