require 'spec_helper'
require 'mail'

module Roadie
  module Rails
    describe Automatic do
      base_mailer = Class.new do
        def initialize(email = nil)
          @email = email
        end

        def mail(options = {})
          @email
        end
      end

      some_mailer = Class.new(base_mailer) do
        include Automatic
      end

      describe "#roadie_options" do
        it "returns Rails' roadie config" do
          ::Rails.stub_chain :application, :config, roadie: "roadie config"
          some_mailer.new.roadie_options.should == "roadie config"
        end
      end

      describe "#mail" do
        let(:email) { Mail.new(to: "foo@example.com", from: "me@example.com") }
        let(:instance) { some_mailer.new(email) }

        before { instance.stub roadie_options: Options.new }

        it "inlines the email when it is delivered" do
          inliner = double "Inliner"
          mail = instance.mail
          mail.delivery_method :test

          MailInliner.should_receive(:new).with(email, instance.roadie_options).and_return inliner
          inliner.should_receive(:execute)
          mail.deliver
        end
      end
    end
  end
end
