module Roadie
  module Rails
    # Extend instances of Mail with this to have it inlined automatically when
    # delivered. You'll need to assign some #roadie_options for it to actually
    # do anything.
    module InlineOnDelivery
      attr_accessor :roadie_options

      def deliver
        if (options = roadie_options)
          MailInliner.new(self, options).execute
        end
        super
      end
    end
  end
end
