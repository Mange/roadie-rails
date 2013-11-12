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

      describe "#roadie_options" do
        it "returns Rails' roadie config" do
          ::Rails.stub_chain :application, :config, roadie: "roadie config"
          some_mailer.new.roadie_options.should == "roadie config"
        end
      end

      describe "#roadie_mail" do
        let(:email) { Mail.new }
        let(:instance) { some_mailer.new(email) }

        before { instance.stub roadie_options: Options.new }

        before do
          inliner = double "Mail inliner"
          inliner.stub(:execute) { |email| email }
          MailInliner.stub new: inliner
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
          MailInliner.should_receive(:new).with(email, instance_of(Options)).and_return inliner
          inliner.should_receive(:execute).and_return "inlined email"
          instance.roadie_mail.should == "inlined email"
        end
      end
    end
  end
end
