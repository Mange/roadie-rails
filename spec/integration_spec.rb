require 'spec_helper'
require 'tempfile'
require 'mail'

describe "Integrations" do
  def parse_html_in_email(mail)
    Nokogiri::HTML.parse mail.html_part.body.decoded
  end

  rails_apps = [
    RailsApp.new("Rails 5.1.0", 'rails_51'),
    RailsApp.new("Rails 5.2.0", 'rails_52'),
  ]

  rails_apps.each do |app|
    describe "with #{app}" do
      before { app.reset }

      def validate_email(app, email)
        expect(email.to).to eq(['example@example.org'])
        expect(email.from).to eq(['john@example.com'])
        expect(email).to have(2).parts

        expect(email.text_part.body.decoded).not_to match(/<.*>/)

        html = email.html_part.body.decoded
        expect(html).to include '<!DOCTYPE'
        expect(html).to include '<head'

        document = parse_html_in_email(email)
        expect(document).to have_selector('body h1')

        expected_image_url = 'https://example.app.org/assets/rails-322506f9917889126e81df2833a6eecdf2e394658d53dad347e9882dd4dbf28e.png'
        expect(document).to have_styling('background' => "url(#{expected_image_url})").at_selector('.image')

        # If we deliver mails we can catch weird problems with headers being invalid
        email.delivery_method :test
        email.deliver
      end

      it "inlines styles for multipart emails" do
        validate_email app, app.read_email(:normal_email)
      end

      it "automatically inlines styles with automatic mailer" do
        validate_email app, app.read_delivered_email(:normal_email)
      end

      it "automatically inlines styles with automatic mailer and forced delivery" do
        validate_email app, app.read_delivered_email(:normal_email, force_delivery: true)
      end

      it "inlines no styles when roadie_options are nil" do
        email = app.read_delivered_email(:disabled_email)

        expect(email.to).to eq(['example@example.org'])
        expect(email.from).to eq(['john@example.com'])
        expect(email).to have(2).parts

        document = parse_html_in_email(email)
        expect(document).to have_no_styling.at_selector('.image')

        # If we deliver mails we can catch weird problems with headers being invalid
        email.delivery_method :test
        email.deliver
      end

      it "has a AssetPipelineProvider together with a FilesystemProvider" do
        expect(app.read_providers).to eq(%w[Roadie::FilesystemProvider Roadie::Rails::AssetPipelineProvider])
      end
    end
  end
end
