ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup"
# Workaround for uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger
require "logger"
