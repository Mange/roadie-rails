module Roadie
  module Rails
    module Automatic
      def mail(*args, &block)
        email = super
        email.extend InlineOnDelivery
        # FIXME: If we dup here, we would make everything a bit more thread safe
        email.roadie_options = roadie_options
        email
      end

      def roadie_options
        ::Rails.application.config.roadie
      end

      private
      module InlineOnDelivery
        attr_writer :roadie_options

        def deliver
          MailInliner.new(self, @roadie_options).execute
          super
        end
      end
    end
  end
end
