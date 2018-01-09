class Mailer < ActionMailer::Base
  self.asset_host = 'http://asset.host.com'

  include Roadie::Rails::Mailer

  default from: 'john@example.com'

  def normal_email
    roadie_mail(to: 'example@example.org', subject: "Notification for you") do |format|
      format.html
      format.text
    end
  end

  private
  def roadie_options
    super.combine(url_options: {protocol: "https"})
  end
end
