require 'spec_helper'
require 'tempfile'
require 'mail'

describe "Integrations" do
  def parse_html_in_email(mail)
    Nokogiri::HTML.parse mail.html_part.body.decoded
  end

  rails_apps = [
    RailsApp.new("Rails 4.2.x", 'rails_42', runner: :bin, asset_pipeline: true, digests: false),
    RailsApp.new("Rails 4.2.x (with sprockets-rails 3)", 'rails_42_sprockets_rails_3', runner: :bin, asset_pipeline: true, digests: true, sprockets: 3),
    RailsApp.new("Rails 5.0.x", 'rails_50', runner: :bin, asset_pipeline: true, digests: true, sprockets: 3),
    RailsApp.new("Rails 5.1.0", 'rails_51', runner: :bin, asset_pipeline: true, digests: true, sprockets: 3),
    RailsApp.new("Rails 5.2.0", 'rails_52', runner: :bin, asset_pipeline: true, digests: true, sprockets: 3),
    RailsApp.new("Rails master", 'rails_master', runner: :bin, asset_pipeline: true, digests: true, sprockets: 3)
  ]

  if app = ENV['APP']
    rails_apps.select! { |a| a.path == app }
  end

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

        if app.digested?
          if app.sprockets3_or_later?
            expected_image_url = 'https://example.app.org/assets/rails-322506f9917889126e81df2833a6eecdf2e394658d53dad347e9882dd4dbf28e.png'
          else
            expected_image_url = 'https://example.app.org/assets/rails-231a680f23887d9dd70710ea5efd3c62.png'
          end
        elsif app.using_asset_pipeline?
          expected_image_url = 'https://example.app.org/assets/rails.png'
        else
          expected_image_url = 'https://example.app.org/images/rails.png'
        end
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

      if app.using_asset_pipeline? || app.digested?
        it "has a AssetPipelineProvider together with a FilesystemProvider" do
          expect(app.read_providers).to eq(%w[Roadie::FilesystemProvider Roadie::Rails::AssetPipelineProvider])
        end
      else
        it "only has a FilesystemProvider" do
          expect(app.read_providers).to eq(["Roadie::FilesystemProvider"])
        end
      end
    end
  end
end
