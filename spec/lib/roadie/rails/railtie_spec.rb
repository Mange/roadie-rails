# encoding: UTF-8
require 'spec_helper'

module Roadie
  module Rails
    describe Railtie do
      before do
        ::Rails.stub root: Pathname.new("rails-root")
        Railtie.instance_variable_set('@instance', nil) # Embrace me, Cthulhu!
        Railtie.run_initializers
      end

      describe "asset providers" do
        it "has filesystem providers to common asset paths" do
          providers = Railtie.config.roadie.asset_providers.to_a
          providers.should have(1).item

          providers[0].should be_instance_of(FilesystemProvider)
          providers[0].path.should == "rails-root/public"
        end
      end
    end
  end
end
