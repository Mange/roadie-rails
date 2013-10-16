module Roadie
  module Rails
    module Mailer
      def roadie_mail(options = {}, &block)
        email = mail(options, &block)
        MailInliner.new(email).execute
      end

      def roadie_options
        Options.new
      end
    end
  end
end
