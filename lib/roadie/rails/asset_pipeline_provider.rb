module Roadie
  module Rails
    class AssetPipelineProvider
      include Roadie::AssetProvider

      def initialize(pipeline)
        super()
        @pipeline = pipeline
      end

      def find_stylesheet(name)
        if (asset = @pipeline[name])
          Stylesheet.new("#{asset.pathname} (live compiled)", asset.to_s)
        end
      end
    end
  end
end
