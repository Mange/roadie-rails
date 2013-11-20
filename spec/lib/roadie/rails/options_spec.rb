# encoding: UTF-8
require 'spec_helper'

module Roadie
  module Rails
    describe Options do

      # TODO: Restructure examples by attribute name; test setters

      it "can be constructed with a hash" do
        options = Options.new(url_options: {host: "foo.com"})
        options.url_options.should == {host: "foo.com"}
      end

      it "can set an before and after callback" do
        before = Proc.new {}
        after = Proc.new {}
        options = Options.new(before_transformation: before, after_transformation: after)
        options.before_transformation.should == before
        options.after_transformation.should == after
      end

      it "can have a list of asset providers" do
        provider = double "Asset provider"
        options = Options.new(asset_providers: [provider])
        options.asset_providers.should be_instance_of(Roadie::ProviderList)
        options.asset_providers.to_a.should == [provider]
      end

      it "is mutable" do
        provider = double
        options = Options.new
        options.asset_providers = [provider]
        options.asset_providers.should be_instance_of(Roadie::ProviderList)
        options.asset_providers.to_a.should == [provider]
      end

      describe "default settings" do
        subject(:options) { Options.new }

        its(:url_options) { should be_nil }
        its(:before_transformation) { should be_nil }
        its(:after_transformation) { should be_nil }
        its(:asset_providers) { should be_nil }
      end

      describe "applying" do
        fake_document = Struct.new(:url_options, :before_transformation, :after_transformation, :asset_providers)
        let(:document) { fake_document.new }

        it "applies URL options" do
          Options.new(url_options: {host: "bar.com"}).apply_to document
          document.url_options.should == {host: "bar.com"}
        end

        it "applies transformation callbacks" do
          before, after = double("before"), double("after")
          Options.new(before_transformation: before, after_transformation: after).apply_to document
          document.before_transformation.should == before
          document.after_transformation.should == after
        end

        it "applies asset providers" do
          providers = ProviderList.new [double]
          Options.new(asset_providers: providers).apply_to document
          document.asset_providers.should == providers
        end
      end

      describe "merging" do
        it "replaces options" do
          options = Options.new(url_options: {host: "foo.com", port: 3000})
          options.merge(url_options: {host: "bar.com", protocol: "https"}).url_options.should == {
            host: "bar.com", protocol: "https"
          }
        end

        it "does not mutate" do
          options = Options.new(url_options: {})
          options.merge url_options: {host: "foo.com"}
          options.url_options.should == {}
        end
      end

      describe "destructive merging" do
        it "replaces options" do
          options = Options.new(url_options: {host: "foo.com", port: 3000})
          options.merge! url_options: {host: "bar.com", protocol: "https"}
          options.url_options.should == {host: "bar.com", protocol: "https"}
        end
      end

      shared_examples_for "attribute combination" do
        it "combines the url options" do
          options = Options.new(url_options: {host: "foo.com", port: 3000})
          combine(options, url_options: {host: "bar.com", protocol: "https"}).url_options.should == {
            host: "bar.com", port: 3000, protocol: "https"
          }
        end

        it "combines before callbacks" do
          value = 0
          inc = proc { value += 1 }

          options = Options.new(before_transformation: inc)
          combined = combine(options, before_transformation: inc)

          combined.before_transformation.call(0)
          value.should == 2
        end

        it "combines after callbacks" do
          value = 0
          inc = proc { value += 1 }

          options = Options.new(after_transformation: inc)
          combined = combine(options, after_transformation: inc)

          combined.after_transformation.call(0)
          value.should == 2
        end

        it "combines asset providers" do
          provider1 = double "Asset provider 1"
          provider2 = double "Asset provider 2"
          options = Options.new(asset_providers: [provider1])
          combined = combine(options, asset_providers: [provider2])
          combined.asset_providers.to_a.should == [provider1, provider2]
        end

        it "combines asset provider lists" do
          provider1 = double "Asset provider 1"
          provider2 = double "Asset provider 2"
          options = Options.new(asset_providers: [provider1])
          combined = combine(options, asset_providers: ProviderList.new([provider2]))
          combined.asset_providers.to_a.should == [provider1, provider2]
        end

        it "appends singular asset providers" do
          provider1 = double "Asset provider 1"
          provider2 = double "Asset provider 2"
          options = Options.new(asset_providers: [provider1])
          combined = combine(options, asset_providers: provider2)
          combined.asset_providers.to_a.should == [provider1, provider2]
        end
      end

      describe "combining" do
        it_behaves_like "attribute combination"

        def combine(instance, options)
          instance.combine(options)
        end

        it "does not mutate" do
          options = Options.new(url_options: {})
          options.combine url_options: {host: "foo.com"}
          options.url_options.should == {}
        end
      end

      describe "desctructive combination" do
        it_behaves_like "attribute combination"

        def combine(instance, options)
          instance.combine!(options)
          instance
        end

        it "mutates" do
          options = Options.new(url_options: {})
          options.combine! url_options: {host: "foo.com"}
          options.url_options.should == {host: "foo.com"}
        end
      end
    end
  end
end
