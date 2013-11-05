module Roadie
  module Rails
    class Options
      attr_reader :url_options, :before_transformation, :after_transformation, :asset_providers

      def initialize(options = {})
        @url_options           = options.fetch :url_options, {}
        @before_transformation = options[:before_transformation]
        @after_transformation  = options[:after_transformation]
        if options.has_key?(:asset_providers)
          @asset_providers = ProviderList.wrap options[:asset_providers]
        end
      end
    end
  end
end
