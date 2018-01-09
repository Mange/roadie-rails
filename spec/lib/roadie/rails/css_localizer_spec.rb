require 'spec_helper'

module Roadie
  module Rails
    describe CssLocalizer do
      base_mailer = Class.new do
        cattr_accessor :asset_host
      end

      describe "#asset_host" do
        it "passes all arguments to the underlying simple accessor" do
          string_host_mailer = Class.new(base_mailer) do
            self.asset_host = 'http://original.com'

            include CssLocalizer
          end

          asset_host = string_host_mailer.asset_host
          expect(asset_host).to be_a(Proc)
          expect(asset_host.call('foo.png')).to eq('http://original.com')
        end

        it "passes all arguments to the underlying proc accessor" do
          proc_host_mailer = Class.new(base_mailer) do
            self.asset_host = Proc.new { |source, request|
              'http://original.com'
            }

            include CssLocalizer
          end

          asset_host = proc_host_mailer.asset_host
          expect(asset_host).to be_a(Proc)
          expect(asset_host.call('foo.png')).to eq('http://original.com')
        end
      end
    end
  end
end
