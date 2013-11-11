module Roadie
  module Rails
    class Options
      attr_reader :url_options, :before_transformation, :after_transformation, :asset_providers

      def initialize(options = {})
        @url_options           = options[:url_options]
        @before_transformation = options[:before_transformation]
        @after_transformation  = options[:after_transformation]
        if options.has_key?(:asset_providers)
          @asset_providers = ProviderList.wrap options[:asset_providers]
        end
      end

      def apply_to(document)
        document.url_options = url_options
        document.before_transformation = before_transformation
        document.after_transformation = after_transformation
        document.asset_providers = asset_providers
      end
    end
  end
end
