class RailsApp
  def initialize(name, path, options = {})
    @name = name
    @path = File.expand_path("../../railsapps/#{path}", __FILE__)
    @runner = options.fetch(:runner)
    @using_asset_pipeline = options.fetch(:asset_pipeline)
    @digests = options.fetch(:digests)
    @sprockets3 = options[:sprockets3]
    reset
  end

  def to_s() @name end
  def using_asset_pipeline?() @using_asset_pipeline end
  def digested?() @digests end
  def sprockets3?() @sprockets3 end

  def read_email(mail_name)
    result = run("puts Mailer.#{mail_name}.to_s")
    raise "No email returned. Did the rails application crash?" if result.strip.empty?
    Mail.read_from_string(result)
  end

  def read_delivered_email(mail_name, options = {})
    deliver = options[:force_delivery] ? "deliver!" : "deliver" 
    result = run("mail = AutoMailer.#{mail_name}; mail.delivery_method(:test); mail.#{deliver}; puts mail.to_s")
    raise "No email returned. Did the rails application crash?" if result.strip.empty?
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
  end

  def before_mail(code)
    @extra_code << "\n" << code << "\n"
  end

  private
  def run(code)
    Tempfile.open('code') do |file|
      file << @extra_code unless @extra_code.empty?
      file << code
      file.close
      run_file_in_app_context file.path
    end
  end

  def run_file_in_app_context(file_path)
    # Unset environment variables set by Bundler to get a clean slate
    IO.popen(<<-SH).read
      unset BUNDLE_GEMFILE;
      unset RUBYOPT;
      export RAILS_ENV=development
      cd #{@path.shellescape} && #{runner_script} #{file_path.shellescape}
    SH
  end

  def runner_script
    case @runner
    when :script then "script/rails runner"
    when :bin then "bin/rails runner"
    else raise "Unknown runner type: #{@runner}"
    end
  end
end

