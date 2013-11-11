# encoding: UTF-8
require 'spec_helper'

module Roadie
  module Rails
    describe Options do
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
    end
  end
end
