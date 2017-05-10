require "bundler/gem_tasks"

desc "Install gems for embedded Rails apps"
task :install_gems do
  Bundler.with_clean_env do
    sh "./setup.sh install"
  end
end

desc "Update gems for embedded Rails apps"
task :update_gems do
  Bundler.with_clean_env do
    sh "./setup.sh update"
  end
end

desc "Run specs"
task :spec do
  sh "bundle exec rspec -f progress"
end

desc "Default: Update gems and run specs"
task :default => [:update_gems, :spec]
