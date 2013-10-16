require 'spec_helper'
require 'mail'

module Roadie
  module Rails
    describe Mailer do
      some_mailer = Class.new do
        include Mailer

        def initialize(email = nil)
          @email = email
        end

        def mail(options = {})
          @email
        end
      end

      it "adds the #roadie_mail method" do
        some_mailer.new.should respond_to(:roadie_mail)
      end

      it "adds the #roadie_options method" do
        some_mailer.new.should respond_to(:roadie_options)
      end

      describe "#roadie_mail" do
        let(:email) { Mail.new }
        let(:instance) { some_mailer.new(email) }

        before do
          inliner = double "Mail inliner"
          inliner.stub(:execute) { |email| email }
          stub_const "Roadie::Rails::MailInliner", double("MailInliner", new: inliner)
        end

        it "calls the original mail method with all options and the block" do
          instance.should_receive(:mail) do |options, &block|
            options.should == {some: "option"}
            block.should_not be_nil
            email
          end

          instance.roadie_mail(some: "option") { }
        end

        it "inlines the email" do
          inliner = double "Inliner"
          MailInliner.should_receive(:new).with(email).and_return inliner
          inliner.should_receive(:execute).and_return "inlined email"
          instance.roadie_mail.should == "inlined email"
        end
      end

      describe "#roadie_options" do
        it "returns a Roadie::Rails::Options instance" do
          some_mailer.new.roadie_options.should be_instance_of(Roadie::Rails::Options)
        end
      end
    end
  end
end
