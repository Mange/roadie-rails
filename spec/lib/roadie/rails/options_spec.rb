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
        options = Options.new(before_callback: before, after_callback: after)
        options.before_callback.should == before
        options.after_callback.should == after
      end

      describe "default settings" do
        subject(:options) { Options.new }

        its(:url_options) { should be_empty }
        its(:before_callback) { should be_nil }
        its(:after_callback) { should be_nil }
      end
    end
  end
end
