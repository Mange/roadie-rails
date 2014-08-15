# encoding: UTF-8
require 'spec_helper'

module Roadie
  module Rails
    describe Railtie do
      let(:rails_application) { double "Application", config: ::Rails::Railtie::Configuration.new }

      before do
        allow(::Rails).to receive(:root).and_return Pathname.new("rails-root")
        allow(::Rails).to receive(:application).and_return rails_application
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
          expect(providers).to have(1).item

          expect(providers[0]).to be_instance_of(FilesystemProvider)
          expect(providers[0].path).to eq("rails-root/public")
        end

        it "also gets a AssetPipelineProvider if assets are enabled" do
          rails_application.config.assets = ActiveSupport::OrderedOptions.new(enabled: true)

          asset_pipeline = double "The asset pipeline"
          allow(rails_application).to receive(:assets).and_return asset_pipeline
          run_initializer

          providers = Railtie.config.roadie.asset_providers.to_a
          expect(providers).to have(2).items
          expect(providers[0]).to be_instance_of(FilesystemProvider)
          expect(providers[1]).to be_instance_of(AssetPipelineProvider)
          expect(providers[1].pipeline).to eq(asset_pipeline)
        end

        # This happens inside a Rails engine as the parent app is the one
        # holding on to the pipeline.
        it "gets no AssetPipelineProvider if assets are enabled but not available" do
          rails_application.config.assets = ActiveSupport::OrderedOptions.new(enabled: true)
          allow(rails_application).to receive(:assets).and_return nil

          run_initializer

          providers = Railtie.config.roadie.asset_providers.to_a
          expect(providers).to have(1).item
          expect(providers[0]).to be_instance_of(FilesystemProvider)
        end
      end
    end
  end
end
