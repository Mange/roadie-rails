# encoding: UTF-8
require 'spec_helper'
require 'mail'

module Roadie
  module Rails
    describe MailInliner do
      let(:email) { Mail.new }
      let(:options) { Options.new }
      subject(:inliner) { MailInliner.new(email, options) }

      it "takes an email and options" do
        inliner = MailInliner.new(email, options)
        expect(inliner.email).to eq(email)
        expect(inliner.options).to eq(options)
      end

      context "with an plaintext email" do
        let(:email) do
          Mail.new do
            body "Hello world"
          end
        end

        it "returns the email without doing anything" do
          expect(inliner.execute).to eq(email)
          expect(email.html_part).to be_nil
          expect(email.body.decoded).to eq("Hello world")
        end

        it "does nothing when given nil options" do
          inliner = MailInliner.new(email, nil)
          expect { inliner.execute }.to_not raise_error
        end
      end

      context "with an HTML email" do
        let(:html) { "<h1>Hello world!</h1>" }
        let(:email) do
          html_string = html
          Mail.new do
            content_type 'text/html; charset=UTF-8'
            body html_string
          end
        end

        it "adjusts the html part using Roadie" do
          document = double "A document", transform: "transformed HTML"
          expect(DocumentBuilder).to receive(:build).with(html, instance_of(Options)).and_return document

          inliner.execute

          expect(email.body.decoded).to eq("transformed HTML")
        end

        it "does nothing when given nil options" do
          inliner = MailInliner.new(email, nil)
          expect { inliner.execute }.to_not raise_error
        end
      end

      context "with an multipart email" do
        let(:html) { "<h1>Hello world!</h1>" }
        let(:email) do
          html_string = html
          Mail.new do
            text_part { body "Hello world" }
            html_part { body html_string }
          end
        end

        it "returns the email" do
          expect(inliner.execute).to eq(email)
        end

        it "adjusts the html part using Roadie" do
          document = double "A document", transform: "transformed HTML"
          expect(DocumentBuilder).to receive(:build).with(html, instance_of(Options)).and_return document

          inliner.execute

          expect(email.html_part.body.decoded).to eq("transformed HTML")
        end

        it "does nothing when given nil options" do
          inliner = MailInliner.new(email, nil)
          expect { inliner.execute }.to_not raise_error
        end
      end
    end
  end
end
