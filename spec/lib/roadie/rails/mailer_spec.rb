# frozen_string_literal: true

require "spec_helper"
require "mail"

module Roadie
  module Rails
    describe Mailer do
      some_mailer = Class.new do
        include Mailer

        def initialize(email = nil)
          @email = email
        end

        def mail(_options = {})
          @email
        end
      end

      describe "#roadie_options" do
        it "returns Rails' roadie config" do
          allow(::Rails).to receive_message_chain(
            :application, :config, :roadie
          ).and_return("roadie config")
          expect(some_mailer.new.roadie_options).to eq("roadie config")
        end
      end

      describe "#roadie_mail" do
        let(:email) { Mail.new }
        let(:instance) { some_mailer.new(email) }

        before do
          allow(instance).to receive(:roadie_options).and_return(Options.new)
        end

        before do
          inliner = double "Mail inliner"
          allow(inliner).to receive(:execute) { |email| email }
          allow(MailInliner).to receive(:new).and_return(inliner)
        end

        it "calls the original mail method with all options and the block" do
          expect(instance).to receive(:mail) do |options, &block|
            expect(options).to eq(some: "option")
            expect(block).not_to be_nil
            email
          end

          instance.roadie_mail(some: "option") {}
        end

        it "inlines the email" do
          inliner = instance_double(MailInliner, execute: "inlined email")
          allow(MailInliner).to receive(:new).and_return(inliner)

          expect(instance.roadie_mail).to eq("inlined email")

          expect(MailInliner).to have_received(:new).with(
            email,
            instance_of(Options)
          )
          expect(inliner).to have_received(:execute)
        end

        it "allows to override roadie options" do
          inliner = instance_double(MailInliner, execute: "inlined email")
          allow(MailInliner).to receive(:new).and_return(inliner)

          expect(
            instance.roadie_mail({}, foo: "bar")
          ).to eq("inlined email")

          expect(MailInliner).to have_received(:new).with(email, foo: "bar")
          expect(inliner).to have_received(:execute)
        end
      end
    end
  end
end
