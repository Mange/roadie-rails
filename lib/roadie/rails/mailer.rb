module Roadie
  module Rails
    module Mailer
      def roadie_mail(options = {}, &block)
        email = mail(options, &block)
        MailInliner.new(email, roadie_options).execute
      end

      def roadie_options
        ::Rails.application.config.roadie
      end
    end
  end
end
