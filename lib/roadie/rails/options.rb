module Roadie
  module Rails
    class Options
      attr_reader :url_options, :before_transformation, :after_transformation, :asset_providers

      def initialize(options = {})
        # TODO: Crash on unexpected keys
        self.url_options           = options[:url_options]
        self.before_transformation = options[:before_transformation]
        self.after_transformation  = options[:after_transformation]
        self.asset_providers       = options[:asset_providers]
      end

      def url_options=(options)
        @url_options = options
      end

      def before_transformation=(callback)
        @before_transformation = callback
      end

      def after_transformation=(callback)
        @after_transformation = callback
      end

      def asset_providers=(providers)
        if providers
          @asset_providers = ProviderList.wrap providers
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
