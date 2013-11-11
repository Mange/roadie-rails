module Roadie
  module Rails
    class DocumentBuilder
      class << self
        def build(html, options)
          new.build(html, options)
        end
        private :new
      end

      def build(html, options)
        document = Document.new(html)
        options.apply_to document
        document
      end
    end
  end
end
