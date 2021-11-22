# frozen_string_literal: true

class RailsApp
  def initialize(name, path)
    @name = name
    @path = File.expand_path("../../railsapps/#{path}", __FILE__)
    reset
  end

  def to_s
    @name
  end

  def read_email(mail_name)
    result = run("puts Mailer.#{mail_name}.to_s")

    if result.strip.empty?
      raise "No email returned. Did the rails application crash?"
    end

    Mail.read_from_string(result)
  end

  def read_delivered_email( # rubocop:disable Metrics/MethodLength
    mail_name,
    options = {}
  )
    deliver = options[:force_delivery] ? "deliver!" : "deliver"
    result = run(<<~RUBY)
      mail = AutoMailer.#{mail_name}
      mail.delivery_method(:test)
      mail.#{deliver}
      puts mail.to_s
    RUBY

    if result.strip.empty?
      raise "No email returned. Did the rails application crash?"
    end

    Mail.read_from_string(result)
  end

  def read_providers
    result = run(<<-RUBY).strip
      providers = Rails.application.config.roadie.asset_providers
      puts providers.map { |p| p.class.name }.join(',')
    RUBY
    raise "No output present. Did the application crash?" if result.empty?

    result.split(",")
  end

  def reset
    @extra_code = ""
    run_in_app_context "mkdir -p tmp"
    run_in_app_context "rm -rf tmp/cache"
  end

  def before_mail(code)
    @extra_code << "\n" << code << "\n"
  end

  private
  def run(code)
    Tempfile.open("code") do |file|
      file << @extra_code unless @extra_code.empty?
      file << code
      file.close
      run_file_in_app_context file.path
    end
  end

  def run_file_in_app_context(file_path)
    run_in_app_context "bin/rails runner #{file_path.shellescape}"
  end

  def run_in_app_context(command)
    Bundler.with_unbundled_env do
      Dir.chdir @path do
        IO.popen(command).read
      end
    end
  end
end
