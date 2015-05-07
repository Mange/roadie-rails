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
        if (asset = find_asset_in_pipeline(name))
          Stylesheet.new("#{asset.pathname} (live compiled)", asset.to_s)
        end
      end

      private
      def find_asset_in_pipeline(name)
        normalized_name = normalize_asset_name(name)
        @pipeline[normalized_name] || @pipeline[remove_asset_digest(normalized_name)]
      end

      def normalize_asset_name(href)
        remove_asset_prefix(href.split('?').first)
      end

      DIGEST_PATTERN = /
        -                # Digest comes after a dash
        (?:
         [a-z0-9]{32} |  # Old style is 32 character hash
         [a-z0-9]{64}    # New style is 64 characters
        )
        \.               # Dot for the file extension
      /x.freeze

      def remove_asset_digest(path)
        path.gsub(DIGEST_PATTERN, '.')
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
