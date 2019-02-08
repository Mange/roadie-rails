# frozen_string_literal: true

require "spec_helper"

module Roadie
  module Rails
    describe DocumentBuilder do
      it "builds documents with the given HTML" do
        document = DocumentBuilder.build("foo", Options.new)
        expect(document.html).to eq("foo")
      end

      it "applies the options to the document" do
        options = Options.new
        allow(options).to receive(:apply_to).and_call_original

        DocumentBuilder.build("", options)

        expect(options).to have_received(:apply_to).with(instance_of(Document))
      end
    end
  end
end
