require 'spec_helper'
require 'roadie/rspec'

module Roadie
  module Rails
    describe AssetPipelineProvider do
      let(:pipeline) { FakePipeline.new }

      it_behaves_like "roadie asset provider", valid_name: "existing.css", invalid_name: "bad.css" do
        subject { AssetPipelineProvider.new(pipeline) }
        before do
          pipeline.add_asset "existing.css", ""
        end
      end

      describe "finding stylesheets" do
        it "searches the asset pipeline" do
          pipeline.add_asset "/path/to/good.css.scss", "body { color: red; }"
          provider = AssetPipelineProvider.new(pipeline)

          stylesheet = provider.find_stylesheet("good.css")
          stylesheet.name.should == "/path/to/good.css.scss (live compiled)"
          stylesheet.to_s.should == "body{color:red}"
        end
      end

      class FakePipeline
        # Interface
        def [](name)
          @files.find { |file|
            File.basename(file.pathname).index(name) == 0
          }
        end

        # Test helpers
        def initialize() @files = [] end
        def add_asset(name, content) @files << AssetFile.new(name, content) end
        private
        AssetFile = Struct.new(:pathname, :to_s)
      end
    end
  end
end
