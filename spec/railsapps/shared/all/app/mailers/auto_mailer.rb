class AutoMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: 'john@example.com'

  def normal_email
    generate_email
  end

  def disabled_email
    generate_email
  end

  private
  def roadie_options
    unless action_name =~ /disabled/
      super.combine(url_options: {protocol: "https"})
    end
  end

  def generate_email
    mail(to: 'example@example.org', subject: "Notification for you") do |format|
      format.html { render :normal_email }
      format.text { render :normal_email }
    end
  end
end
