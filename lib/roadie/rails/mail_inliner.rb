module Roadie
  module Rails
    class MailInliner
      attr_reader :email, :options

      def initialize(email, options)
        @email = email
        @options = options
      end

      def execute
        if options
          improve_body if email.content_type =~ /^text\/html/
          improve_html_part(email.html_part) if email.html_part
        end
        email
      end

      private
      def improve_body
        email.body = transform_html(email.body.decoded)
      end

      def improve_html_part(html_part)
        html_part.body = transform_html(html_part.body.decoded)
      end

      def transform_html(old_html)
        DocumentBuilder.build(old_html, options).transform
      end
    end
  end
end
