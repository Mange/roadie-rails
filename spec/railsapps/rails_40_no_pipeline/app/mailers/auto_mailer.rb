class AutoMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: 'john@example.com'

  def normal_email
    mail(to: 'example@example.org', subject: "Notification for you") do |format|
      format.html
      format.text
    end
  end

  private
  def roadie_options
    super.combine(url_options: {protocol: "https"})
  end
end
