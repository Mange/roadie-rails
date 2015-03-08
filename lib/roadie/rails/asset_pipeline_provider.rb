module Roadie
  module Rails
    class AssetPipelineProvider
      include Roadie::AssetProvider
      attr_reader :pipeline

      def initialize(pipeline)
        raise ArgumentError, "You need to pass a pipeline to initialize AssetPipelineProvider" unless pipeline
        super()
        @pipeline = pipeline
      end

      def find_stylesheet(name)
        if (asset = @pipeline[normalize_asset_name name])
          Stylesheet.new("#{asset.pathname} (live compiled)", asset.to_s)
        end
      end

      private
      def normalize_asset_name(href)
        res = remove_asset_prefix href.split('?').first
        remove_asset_digest res
      end

      def remove_asset_digest(path)
        path.gsub /-[a-z0-9]{32}\./, '.'
      end

      def remove_asset_prefix(path)
        path.sub(Regexp.new("^#{Regexp.quote(asset_prefix)}/?"), "")
      end

      def asset_prefix
        ::Rails.application.try(:config).try(:assets).try(:prefix) || "/assets"
      end
    end
  end
end
