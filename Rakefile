require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

task :test_rubies do
  system "rvm 1.8.7@halo-reach-api_gem,1.9.2@halo-reach-api_gem,1.9.3@halo-reach-api_gem do rake test"
end