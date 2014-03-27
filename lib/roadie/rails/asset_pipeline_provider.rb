module Roadie
  module Rails
    class AssetPipelineProvider
      include Roadie::AssetProvider
      attr_reader :pipeline

      def initialize(pipeline)
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
        File.basename href.split('?').first
      end
    end
  end
end
