module Roadie
  module Rails
    class MailInliner
      attr_reader :email, :options

      def initialize(email, options)
        @email = email
        @options = options
      end

      def execute
        improve_html_part(email.html_part) if email.html_part
        email
      end

      private
      def improve_html_part(html_part)
        html_part.body = make_new_html(html_part.body.decoded)
      end

      def make_new_html(old_html)
        DocumentBuilder.build(old_html, options).transform
      end
    end
  end
end
