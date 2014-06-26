require 'spec_helper'
require 'roadie/rspec'

module Roadie
  module Rails
    describe AssetPipelineProvider do
      let(:pipeline) { FakePipeline.new }

      it_behaves_like "roadie asset provider", valid_name: "existing.css", invalid_name: "bad.css" do
        subject { AssetPipelineProvider.new(pipeline) }
        before do
          pipeline.add_asset "existing.css", "existing.css", ""
        end
      end

      describe "finding stylesheets" do
        it "searches the asset pipeline" do
          pipeline.add_asset "good.css", "/path/to/good.css.scss", "body { color: red; }"
          provider = AssetPipelineProvider.new(pipeline)

          stylesheet = provider.find_stylesheet("good.css")
          expect(stylesheet.name).to eq("/path/to/good.css.scss (live compiled)")
          expect(stylesheet.to_s).to eq("body{color:red}")
        end

        it "ignores query string and asset prefix" do
          pipeline.add_asset "good.css", "good.css.scss", ""
          provider = AssetPipelineProvider.new(pipeline)
          expect(provider.find_stylesheet("/assets/good.css?body=1")).not_to be_nil
        end
      end

      class FakePipeline
        # Interface
        def [](name)
          @files.find { |file| file.matching_name == name }
        end

        # Test helpers
        def initialize() @files = [] end
        def add_asset(matching_name, path, content) @files << AssetFile.new(matching_name, path, content) end
        private
        AssetFile = Struct.new(:matching_name, :pathname, :to_s)
      end
    end
  end
end
