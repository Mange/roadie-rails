require 'spec_helper'
require 'mail'

module Roadie
  module Rails
    describe Mailer do
      base_mailer = Class.new do
        cattr_accessor :asset_host

        def initialize(email = nil)
          @email = email
        end

        def mail(options = {})
          @email
        end
      end

      some_mailer = Class.new(base_mailer) do
        include Mailer
      end

      describe "#roadie_options" do
        it "returns Rails' roadie config" do
          allow(::Rails).to receive_message_chain(:application, :config, :roadie).and_return "roadie config"
          expect(some_mailer.new.roadie_options).to eq("roadie config")
        end
      end

      describe "#roadie_mail" do
        let(:email) { Mail.new }
        let(:instance) { some_mailer.new(email) }

        before { allow(instance).to receive(:roadie_options).and_return(Options.new) }

        before do
          inliner = double "Mail inliner"
          allow(inliner).to receive(:execute) { |email| email }
          allow(MailInliner).to receive(:new).and_return(inliner)
        end

        it "calls the original mail method with all options and the block" do
          expect(instance).to receive(:mail) do |options, &block|
            expect(options).to eq({some: "option"})
            expect(block).not_to be_nil
            email
          end

          instance.roadie_mail(some: "option") { }
        end

        it "inlines the email" do
          inliner = double "Inliner"
          expect(MailInliner).to receive(:new).with(email, instance_of(Options)).and_return inliner
          expect(inliner).to receive(:execute).and_return "inlined email"
          expect(instance.roadie_mail).to eq("inlined email")
        end
      end

      describe "#asset_host" do
        it "passes all arguments to the underlying simple accessor" do
          string_host_mailer = Class.new(base_mailer) do
            self.asset_host = 'http://original.com'

            include Automatic
          end

          asset_host = string_host_mailer.asset_host
          expect(asset_host).to be_a(Proc)
          expect(asset_host.call('foo.png')).to eq('http://original.com')
        end

        it "passes all arguments to the underlying proc accessor" do
          proc_host_mailer = Class.new(base_mailer) do
            self.asset_host = Proc.new { |source, request|
              'http://original.com'
            }

            include Automatic
          end

          asset_host = proc_host_mailer.asset_host
          expect(asset_host).to be_a(Proc)
          expect(asset_host.call('foo.png')).to eq('http://original.com')
        end
      end
    end
  end
end
