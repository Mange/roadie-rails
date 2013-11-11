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
        inliner.email.should == email
        inliner.options.should == options
      end

      context "with an plaintext email" do
        let(:email) do
          Mail.new do
            body "Hello world"
          end
        end

        it "returns the email without doing anything" do
          inliner.execute.should == email
          email.html_part.should be_nil
          email.body.decoded.should == "Hello world"
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
          inliner.execute.should == email
        end

        it "adjusts the html part using Roadie" do
          document = double "A document", transform: "transformed HTML"
          DocumentBuilder.should_receive(:build).with(html, instance_of(Options)).and_return document

          inliner.execute

          email.html_part.body.decoded.should == "transformed HTML"
        end
      end
    end
  end
end
