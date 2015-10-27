# encoding: utf-8
require "bundler/gem_tasks"
require "yard"
require "yard/rake/yardoc_task"
require "rspec/core/rake_task"

desc "Run RSpec code examples"
namespace :spec do
  desc "Run offline RSpec code examples"
  RSpec::Core::RakeTask.new(:offline) do |t|
    t.rspec_opts = "--tag offline"
  end

  desc "Run online RSpec code examples"
  RSpec::Core::RakeTask.new(:online) do |t|
    t.rspec_opts = "--tag online"
  end

  RSpec::Core::RakeTask.new(:all) do |t|
    t.rspec_opts = "--tag offline --tag online"
  end
end

desc "Run all RSpec code examples"
task :spec => 'spec:all'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.stats_options = ['--list-undoc']
end

task :default => "spec:offline"
