gem 'rspec', '>=3.4'
gem 'rubocop', '~>0.34.2'
gem 'foodcritic', '~>5.0.0'
gem 'test-kitchen', '~>1.15.0'
require 'rake'
require 'rspec'
require 'rubocop'
require 'foodcritic'

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run rubocop style checks'
  RuboCop::RakeTask.new(:ruby)
  require 'foodcritic'
  desc 'Run foodcritic style checks'
  FoodCritic::Rake::LintTask.new(:chef)
end

namespace :spec do
  require 'rspec/core/rake_task'
  desc 'Run rspec tests'
  RSpec::Core::RakeTask.new(:spec)
end

namespace :integration do
  require 'kitchen/cli'
  task :vagrant do
    desc 'Run kitchen-vagrant tests'
    ENV['KITCHEN_YAML'] = '.kitchen.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end
  task :ec2 do
    desc 'Run kitchen-ec2 tests'
    ENV['KITCHEN_YAML'] = '.kitchen.ec2.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end

  task :ubuntu do
    desc 'Run Ubuntu kitchen-test'
    ENV['KITCHEN_YAML'] = '.kitchen.ubuntu.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end

  task :rhel do
    desc 'Run rhel kitchen-test'
    ENV['KITCHEN_YAML'] = '.kitchen.rhel.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end

  task :amzn do
    desc 'Run amzn kitchen-test'
    ENV['KITCHEN_YAML'] = '.kitchen.amazon.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end

  task :centos do
    desc 'Run centos kitchen-test'
    ENV['KITCHEN_YAML'] = '.kitchen.centos.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end

  task :debian do
    desc 'Run debian kitchen-test'
    ENV['KITCHEN_YAML'] = '.kitchen.debian.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end

  task :oracle do
    desc 'Run Oracle kitchen-test'
    ENV['KITCHEN_YAML'] = '.kitchen.oracle.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end

  task :windows do
    desc 'Run kitchen-windows tests'
    ENV['KITCHEN_YAML'] = '.kitchen.windows.yml'
    Kitchen::CLI.new([], concurrency: 2, destroy: 'always').test
  end
end

desc 'Runs all style checks'
task style: ['style:chef', 'style:ruby']

desc 'Runs spec tests'
task spec: ['spec:spec']

desc 'Runs all integration tests using kitchen-vagrant and kitchen-ec2'
task integration: ['integration:vagrant', 'integration:ec2']
task cloud: [:style, :spec, 'integration:ec2']
task travis: [:style, :spec]

task default: [:style, :spec, :integration]
