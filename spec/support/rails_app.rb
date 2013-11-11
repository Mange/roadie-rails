class RailsApp
  def initialize(name, path, options = {})
    @name = name
    @path = File.expand_path("../../railsapps/#{path}", __FILE__)
    @runner = options.fetch(:runner, :script)
    reset
  end

  def to_s() @name end

  def read_email(mail_name)
    Mail.read_from_string run("puts Mailer.#{mail_name}.to_s")
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

