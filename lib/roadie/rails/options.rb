# frozen_string_literal: true

module Roadie
  module Rails
    class Options
      ATTRIBUTE_NAMES = %i[
        after_transformation
        asset_providers
        before_transformation
        external_asset_providers
        keep_uninlinable_css
        url_options
      ].freeze
      private_constant :ATTRIBUTE_NAMES

      attr_reader(*ATTRIBUTE_NAMES)
      attr_writer(
        :url_options,
        :before_transformation,
        :after_transformation,
        :keep_uninlinable_css,
      )

      def initialize(options = {})
        complain_about_unknown_keys options.keys
        options.each_pair do |name, value|
          self[name] = value
        end
      end

      def asset_providers=(providers)
        # TODO: Raise an error when setting to nil in order to make this not a
        # silent error.
        if providers
          @asset_providers = ProviderList.wrap providers
        end
      end

      def external_asset_providers=(providers)
        # TODO: Raise an error when setting to nil in order to make this not a
        # silent error.
        if providers
          @external_asset_providers = ProviderList.wrap providers
        end
      end

      def apply_to(document)
        document.url_options = url_options
        document.before_transformation = before_transformation
        document.after_transformation = after_transformation

        document.asset_providers = asset_providers if asset_providers

        if external_asset_providers
          document.external_asset_providers = external_asset_providers
        end

        unless keep_uninlinable_css.nil?
          document.keep_uninlinable_css = keep_uninlinable_css
        end
      end

      def merge(options)
        dup.merge! options
      end

      def merge!(options)
        ATTRIBUTE_NAMES.each do |attribute|
          self[attribute] = options.fetch(attribute, self[attribute])
        end
        self
      end

      def combine(options)
        dup.combine! options
      end

      def combine!(options) # rubocop:disable Metrics/MethodLength
        %i[after_transformation before_transformation].each do |name|
          self[name] = Utils.combine_callable(self[name], options[name])
        end

        %i[asset_providers external_asset_providers].each do |name|
          self[name] = Utils.combine_providers(self[name], options[name])
        end

        if options.key?(:keep_uninlinable_css)
          self.keep_uninlinable_css = options[:keep_uninlinable_css]
        end

        self.url_options = Utils.combine_hash(
          url_options,
          options[:url_options],
        )

        self
      end

      def [](option)
        if ATTRIBUTE_NAMES.include?(option)
          public_send(option)
        else
          raise ArgumentError, "#{option.inspect} is not a valid option"
        end
      end

      def []=(option, value)
        if ATTRIBUTE_NAMES.include?(option)
          public_send("#{option}=", value)
        else
          raise ArgumentError, "#{option.inspect} is not a valid option"
        end
      end

      private
      def complain_about_unknown_keys(keys)
        invalid_keys = keys - ATTRIBUTE_NAMES
        unless invalid_keys.empty?
          raise(
            ArgumentError,
            "Unknown configuration parameters: #{invalid_keys}",
            caller(1),
          )
        end
      end
    end
  end
end
