module Roadie
  module Rails
    class Options
      ATTRIBUTE_NAMES = [
        :after_transformation,
        :asset_providers,
        :before_transformation,
        :external_asset_providers,
        :keep_uninlinable_css,
        :url_options,
      ]
      private_constant :ATTRIBUTE_NAMES
      attr_reader(*ATTRIBUTE_NAMES)

      def initialize(options = {})
        complain_about_unknown_keys options.keys
        self.after_transformation     = options[:after_transformation]
        self.asset_providers          = options[:asset_providers]
        self.before_transformation    = options[:before_transformation]
        self.external_asset_providers = options[:external_asset_providers]
        self.keep_uninlinable_css     = options[:keep_uninlinable_css]
        self.url_options              = options[:url_options]
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

      def keep_uninlinable_css=(bool)
        @keep_uninlinable_css = bool
      end

      def asset_providers=(providers)
        if providers
          @asset_providers = ProviderList.wrap providers
        # TODO: Raise an error when setting to nil in order to make this not a silent error.
        # else
        #   raise ArgumentError, "Cannot set asset_providers to nil. Set to Roadie::NullProvider if you want no external assets inlined."
        end
      end

      def external_asset_providers=(providers)
        if providers
          @external_asset_providers = ProviderList.wrap providers
        # TODO: Raise an error when setting to nil in order to make this not a silent error.
        # else
        #   raise ArgumentError, "Cannot set asset_providers to nil. Set to Roadie::NullProvider if you want no external assets inlined."
        end
      end

      def apply_to(document)
        document.url_options = url_options
        document.before_transformation = before_transformation
        document.after_transformation = after_transformation

        document.asset_providers = asset_providers if asset_providers
        document.external_asset_providers = external_asset_providers if external_asset_providers

        document.keep_uninlinable_css = keep_uninlinable_css unless keep_uninlinable_css.nil?
      end

      def merge(options)
        dup.merge! options
      end

      def merge!(options)
        ATTRIBUTE_NAMES.each do |attribute|
          send "#{attribute}=", options.fetch(attribute, send(attribute))
        end
        self
      end

      def combine(options)
        dup.combine! options
      end

      def combine!(options)
        self.after_transformation = combine_callable(
          after_transformation, options[:after_transformation]
        )

        self.asset_providers = combine_providers(
          asset_providers, options[:asset_providers]
        )

        self.before_transformation = combine_callable(
          before_transformation, options[:before_transformation]
        )

        self.external_asset_providers = combine_providers(
          external_asset_providers, options[:external_asset_providers]
        )

        self.keep_uninlinable_css =
          options[:keep_uninlinable_css] if options.has_key?(:keep_uninlinable_css)

        self.url_options = combine_hash(
          url_options, options[:url_options]
        )

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
          ProviderList.new(a.to_a + Array.wrap(b))
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
