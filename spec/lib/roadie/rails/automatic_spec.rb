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
          allow(::Rails).to receive_message_chain(:application, :config, :roadie).and_return "roadie config"
          expect(some_mailer.new.roadie_options).to eq("roadie config")
        end
      end

      describe "#mail" do
        let(:email) { Mail.new(to: "foo@example.com", from: "me@example.com") }
        let(:roadie_options) { Options.new(url_options: {host: "somehost.com"}) }
        let(:instance) { some_mailer.new(email) }

        before { allow(instance).to receive(:roadie_options).and_return roadie_options }

        it "extends the email with InlineOnDelivery and assigns roadie options" do
          email = instance.mail
          expect(email).to be_kind_of(InlineOnDelivery)
          expect(email.roadie_options).not_to be_nil
          expect(email.roadie_options.url_options).to eq roadie_options.url_options
        end
      end
    end
  end
end
