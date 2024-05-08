# frozen_string_literal: true

module Roadie
  module Rails
    class AssetPropshaftProvider
      include Roadie::AssetProvider

      def initialize
        @stylesheets = {}
      end

      def find_stylesheet(stylesheet_asset_path)
        stylesheet = @stylesheets[stylesheet_asset_path]
        return stylesheet if stylesheet.present?

        asset = find_asset_in_propshaft(stylesheet_asset_path)

        if asset.present?
          stylesheet = Stylesheet.new(stylesheet_asset_path, asset.content.force_encoding("UTF-8"))
          @stylesheets[stylesheet_asset_path] = stylesheet
        end

        stylesheet
      end

      def find_asset_in_propshaft(stylesheet_asset_path)
        digested_name = stylesheet_asset_path.gsub("#{::Rails.configuration.assets.prefix}/", "")

        propshaft_stylesheets.detect { |css| css.digested_path.to_s == digested_name }
      end

      def propshaft_stylesheets
        ::Rails.application.assets.load_path.assets(content_types: [Mime::EXTENSION_LOOKUP["css"]])
      end
    end
  end
end
