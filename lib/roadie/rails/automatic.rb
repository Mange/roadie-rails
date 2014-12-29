require 'active_support/concern'

module Roadie
  module Rails
    module Automatic
      extend ActiveSupport::Concern

      included do
        old_asset_host = self.asset_host
        if old_asset_host
          self.asset_host = Proc.new { |source, request|
            uri = URI::parse(source)
            if uri.path.end_with?('.css')
              nil
            else
              old_asset_host
            end
          }
        end
      end

      def mail(*args, &block)
        super.tap do |email|
          email.extend InlineOnDelivery
          email.roadie_options = roadie_options.try(:dup)
        end
      end

      def roadie_options
        ::Rails.application.config.roadie
      end
    end
  end
end
