module Roadie
  module Rails
    class Options
      private
      ATTRIBUTE_NAMES = [:url_options, :before_transformation, :after_transformation, :asset_providers]

      public
      attr_reader *ATTRIBUTE_NAMES

      def initialize(options = {})
        complain_about_unknown_keys options.keys
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

      def merge(options)
        dup.merge! options
      end

      def merge!(options)
        [:url_options, :before_transformation, :after_transformation, :asset_providers].each do |attribute|
          send "#{attribute}=", options.fetch(attribute, send(attribute))
        end
        self
      end

      def combine(options)
        dup.combine! options
      end

      def combine!(options)
        self.url_options = combine_hash url_options, options[:url_options]
        self.before_transformation = combine_callable before_transformation, options[:before_transformation]
        self.after_transformation = combine_callable after_transformation, options[:after_transformation]
        self.asset_providers = combine_providers asset_providers, options[:asset_providers]
        self
      end

      private
      def combine_hash(first, second)
        combine_nilable(first, second) do |a, b|
          a.merge(b)
        end
      end

      def combine_callable(first, second)
        combine_nilable(first, second) do |a, b|
          proc { |*args| a.call(*args); b.call(*args) }
        end
      end

      def combine_providers(first, second)
        combine_nilable(first, second) do |a, b|
          ProviderList.new a.to_a + Array.wrap(b)
        end
      end

      def combine_nilable(first, second)
        if first && second
          yield first, second
        else
          first ? first : second
        end
      end

      def complain_about_unknown_keys(keys)
        invalid_keys = keys - ATTRIBUTE_NAMES
        if invalid_keys.size > 0
          raise ArgumentError, "Unknown configuration parameters: #{invalid_keys}", caller(1)
        end
      end
    end
  end
end
