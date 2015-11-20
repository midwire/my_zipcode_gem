require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require 'midwire_common/rake_tasks'
rescue StandardError => e
  puts('>>> Can\'t load midwire_common/rake_tasks.')
  puts(">>> Did you 'bundle exec'?: #{e.message}")
  exit
end

require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format progress"
end

task :default => :features
task :test => :features
