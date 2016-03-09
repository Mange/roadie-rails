require "bundler/gem_tasks"

desc "Install gems for embedded Rails apps"
task :install_gems do
  sh "./setup.sh install #{RUBY_VERSION}"
end

desc "Run specs"
task :spec do
  sh "bundle exec rspec -f progress"
end

desc "Default: Install gems and run specs"
task :default => [:install_gems, :spec]
