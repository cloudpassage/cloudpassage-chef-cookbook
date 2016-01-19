require 'rake'
require 'rspec'

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
  task :vagrant do
    puts 'Running Kitchen'
    require 'kitchen/rake_tasks'
    Kitchen::RakeTasks.new
  end
end

desc 'Runs all style checks'
task style: ['style:chef', 'style:ruby']

desc 'Runs spec tests'
task spec: ['spec:spec']

desc 'Runs all integration tests using vagrant'
task integration: ['integration:vagrant']

task default: [:style, :spec, :integration]

# begin
#  require 'kitchen/rake_tasks'
#  Kitchen::RakeTasks.new
# rescue LoadError
#  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
# end
