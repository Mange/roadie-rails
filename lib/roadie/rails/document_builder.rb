module Roadie
  module Rails
    class DocumentBuilder
      def self.build(html, options)
        document = Document.new(html)
        options.apply_to document
        document
      end
    end
  end
end
