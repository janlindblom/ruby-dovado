# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "ruby-dovado"
  gem.homepage = "https://bitbucket.org/janlindblom/ruby-dovado"
  gem.license = "MIT"
  gem.summary = "Ruby library for interfacing Dovado routers."
  gem.description = "Ruby library for interfacing Dovado routers."
  gem.email = "janlindblom@fastmail.fm"
  gem.authors = ["Jan Lindblom"]
  gem.add_dependency 'thread_safe', '~> 0.3'
  gem.add_dependency 'celluloid', '~> 0.15'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
