require 'rails'

module Roadie
  module Rails
    class Railtie < ::Rails::Railtie
      config.roadie = Roadie::Rails::Options.new
      config.after_initialize do
        config.roadie.asset_providers = Roadie::FilesystemProvider.new(::Rails.root)
      end
    end
  end
end
