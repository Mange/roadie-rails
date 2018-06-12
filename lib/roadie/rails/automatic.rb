module Roadie
  module Rails
    module Automatic
      extend ActiveSupport::Concern

      included do
        include CssLocalizer
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
