module Roadie
  module Rails
    class Options
      attr_reader :url_options, :before_callback, :after_callback

      def initialize(options = {})
        @url_options = options.fetch :url_options, {}
        @before_callback = options[:before_callback]
        @after_callback = options[:after_callback]
      end
    end
  end
end
