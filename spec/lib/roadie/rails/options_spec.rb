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

        its(:url_options) { should be_empty }
        its(:before_transformation) { should be_nil }
        its(:after_transformation) { should be_nil }
        its(:asset_providers) { should be_nil }
      end
    end
  end
end
