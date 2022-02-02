# frozen_string_literal: true

require "spec_helper"
require "mail"

module Roadie
  module Rails
    describe InlineOnDelivery do
      it "inlines on #delivery" do
        inliner = instance_double(MailInliner, execute: nil)
        options = instance_double(Options)
        mail = FakeMail.new
        allow(MailInliner).to receive(:new).and_return(inliner)

        mail.extend(InlineOnDelivery)
        mail.roadie_options = options

        expect { mail.deliver }.to change(mail, :delivered?).to(true)

        expect(MailInliner).to have_received(:new).with(mail, options)
        expect(inliner).to have_received(:execute)
      end

      it "inlines on #delivery!" do
        inliner = instance_double(MailInliner, execute: nil)
        options = instance_double(Options)
        mail = FakeMail.new
        allow(MailInliner).to receive(:new).and_return(inliner)

        mail.extend(InlineOnDelivery)
        mail.roadie_options = options

        expect { mail.deliver! }.to change(mail, :delivered?).to(true)

        expect(MailInliner).to have_received(:new).with(mail, options)
        expect(inliner).to have_received(:execute)
      end
    end
  end
end
