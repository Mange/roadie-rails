# frozen_string_literal: true

require "spec_helper"
require "tempfile"
require "mail"

describe "Integrations" do
  def parse_html_in_email(mail)
    Nokogiri::HTML.parse mail.html_part.body.decoded
  end

  rails_apps = [
    RailsApp.new("Rails 5.1.0", "rails_51"),
    RailsApp.new("Rails 5.2.0", "rails_52"),
    RailsApp.new("Rails 6.0.0.beta3", "rails_60"),
    RailsApp.new("Rails 7.0.0.alpha2", "rails_70"),
  ]

  shared_examples "generates valid email" do |message|
    it "inlines styles #{message}" do
      expect(email.to).to eq(["example@example.org"])
      expect(email.from).to eq(["john@example.com"])
      expect(email).to have(2).parts

      expect(email.text_part.body.decoded).not_to match(/<.*>/)

      html = email.html_part.body.decoded
      expect(html).to include "<!DOCTYPE"
      expect(html).to include "<head"

      document = parse_html_in_email(email)
      expect(document).to have_selector("body h1")

      expected_image_url =
        "https://example.app.org/assets/rails-cd95a25e70dfe61add5a96e11d3fee0f29e9ba2b05099723d57bba7dfa725c8a.png"

      expect(document).to have_styling(
        "background" => "url(#{expected_image_url})",
      ).at_selector(".image")

      # If we deliver mails we can catch weird problems with headers being
      # invalid
      email.delivery_method :test
      email.deliver
    end
  end

  rails_apps.each do |app|
    describe "with #{app}" do
      before { app.reset }

      include_examples "generates valid email", "for multipart emails" do
        let(:email) { app.read_email(:normal_email) }
      end

      include_examples "generates valid email", "with automatic mailer" do
        let(:email) { app.read_delivered_email(:normal_email) }
      end

      include_examples(
        "generates valid email",
        "with automatic mailer and forced delivery",
      ) do
        let(:email) do
          app.read_delivered_email(:normal_email, force_delivery: true)
        end
      end

      it "inlines no styles when roadie_options are nil" do
        email = app.read_delivered_email(:disabled_email)

        expect(email.to).to eq(["example@example.org"])
        expect(email.from).to eq(["john@example.com"])
        expect(email).to have(2).parts

        document = parse_html_in_email(email)
        expect(document).to have_no_styling.at_selector(".image")

        # If we deliver mails we can catch weird problems with headers being
        # invalid
        email.delivery_method :test
        email.deliver
      end

      it "has a AssetPipelineProvider together with a FilesystemProvider" do
        expect(app.read_providers).to eq(
          %w[
            Roadie::FilesystemProvider
            Roadie::Rails::AssetPipelineProvider
          ],
        )
      end
    end
  end
end
