# encoding: UTF-8
require 'spec_helper'

module Roadie
  module Rails
    describe DocumentBuilder do
      it "builds documents with the given HTML" do
        document = DocumentBuilder.build("foo", Options.new)
        document.html.should == "foo"
      end

      it "applies the options to the document" do
        options = Options.new
        options.should_receive(:apply_to).with(instance_of Document).and_call_original

        DocumentBuilder.build("", options)
      end
    end
  end
end
