# encoding: UTF-8
require 'spec_helper'

module Roadie
  module Rails
    describe Railtie do
      let(:rails_application) { double "Application", config: ::Rails::Railtie::Configuration.new }

      before do
        ::Rails.stub root: Pathname.new("rails-root"), application: rails_application
      end

      def run_initializer
        # Hack to make the Railtie able to be initialized again
        # Railties are global state, after all, stored on the classes.
        Railtie.instance_variable_set('@instance', nil) # Embrace me, Cthulhu!
        Railtie.instance_variable_set('@ran', nil)
        Railtie.run_initializers :default, rails_application
      end

      describe "asset providers" do
        it "has filesystem providers to common asset paths" do
          run_initializer
          providers = Railtie.config.roadie.asset_providers.to_a
          providers.should have(1).item

          providers[0].should be_instance_of(FilesystemProvider)
          providers[0].path.should == "rails-root/public"
        end

        it "also gets a AssetPipelineProvider if assets are enabled" do
          rails_application.config.assets = ActiveSupport::OrderedOptions.new(enabled: true)

          asset_pipeline = double "The asset pipeline"
          rails_application.stub assets: asset_pipeline
          run_initializer

          providers = Railtie.config.roadie.asset_providers.to_a
          providers.should have(2).items
          providers[0].should be_instance_of(FilesystemProvider)
          providers[1].should be_instance_of(AssetPipelineProvider)
          providers[1].pipeline.should == asset_pipeline
        end
      end
    end
  end
end
