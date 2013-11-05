module Roadie
  module Rails
    class Options
      attr_reader :url_options, :before_transformation, :after_transformation

      def initialize(options = {})
        @url_options = options.fetch :url_options, {}
        @before_transformation = options[:before_transformation]
        @after_transformation = options[:after_transformation]
      end
    end
  end
end
