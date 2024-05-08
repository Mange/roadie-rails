# frozen_string_literal: true

module Roadie
  module Rails
    class AssetPropshaftProvider
      include Roadie::AssetProvider

      def initialize(assembly)
        @assembly = assembly
        @stylesheets = {}
      end

      def find_stylesheet(stylesheet_asset_path)
        stylesheet = @stylesheets[stylesheet_asset_path]
        return stylesheet if stylesheet.present?

        path, digest = extract_path_and_digest(stylesheet_asset_path)

        asset = @assembly.load_path.find(path)
        if asset.present? && asset.fresh?(digest)
          compiled_content = @assembly.compilers.compile(asset)

          stylesheet = Stylesheet.new(stylesheet_asset_path, compiled_content.force_encoding("UTF-8"))
          @stylesheets[stylesheet_asset_path] = stylesheet
        end

        stylesheet
      end

      private

      def extract_path_and_digest(stylesheet_asset_path)
        full_path = stylesheet_asset_path.sub(%r{#{::Rails.configuration.assets.prefix}/}, "")
        digest = full_path[/-([0-9a-zA-Z]{7,128})\.(?!digested)[^.]+\z/, 1]
        path = digest ? full_path.sub("-#{digest}", "") : full_path

        [path, digest]
      end
    end
  end
end
