ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
# Workaround for uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger
require "logger"
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
