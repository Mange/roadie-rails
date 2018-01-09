module Roadie
  module Rails
    module CssLocalizer
      extend ActiveSupport::Concern

      included do
        old_asset_host = self.asset_host
        if old_asset_host
          # don't include an asset_host for CSS files, so that they are picked up by Roadie
          self.asset_host = Proc.new { |source, request|
            uri = URI::parse(source)
            if uri.path.end_with?('.css')
              nil
            else
              # logic copied from Rails
              # http://git.io/vhYx7Q
              if old_asset_host.respond_to?(:call)
                # the original asset_host was a Proc
                arity = old_asset_host.respond_to?(:arity) ? old_asset_host.arity : old_asset_host.method(:call).arity
                args = [source]
                args << request if request && (arity > 1 || arity < 0)
                old_asset_host.call(*args)
              elsif old_asset_host =~ /%d/
                # the original asset_host was a string value that needs the filename checksum added
                old_asset_host % (Zlib.crc32(source) % 4)
              else
                # the original asset_host was a simple string value
                old_asset_host
              end
            end
          }
        end
      end
    end
  end
end
