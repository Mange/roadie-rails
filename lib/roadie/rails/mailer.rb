module Roadie
  module Rails
    module Mailer
      def roadie_mail(options = {}, custom_roadie_options = nil, &block)
        email = mail(options, &block)
        MailInliner.new(email, custom_roadie_options || roadie_options).execute
      end

      def roadie_options
        ::Rails.application.config.roadie
      end
    end
  end
end
