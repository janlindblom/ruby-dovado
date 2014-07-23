# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: ruby-dovado 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-dovado"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jan Lindblom"]
  s.date = "2014-07-22"
  s.description = "Ruby library for interfacing Dovado routers."
  s.email = "jan@janlindblom.se"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/dovado.rb",
    "lib/dovado/client.rb",
    "lib/dovado/router.rb",
    "lib/dovado/router/info.rb",
    "lib/dovado/router/info/operator.rb",
    "lib/dovado/router/info/operator/telia.rb",
    "lib/dovado/router/sms.rb",
    "lib/dovado/router/sms/message.rb",
    "lib/dovado/router/sms/messages.rb",
    "ruby-dovado.gemspec",
    "spec/ruby-dovado_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "https://bitbucket.org/lilycode/ruby-dovado"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.3.0"
  s.summary = "Ruby library for interfacing Dovado routers."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<thread_safe>, ["~> 0.3"])
      s.add_runtime_dependency(%q<thread_safe>, ["~> 0.3"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<thread_safe>, ["~> 0.3"])
      s.add_dependency(%q<thread_safe>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<thread_safe>, ["~> 0.3"])
    s.add_dependency(%q<thread_safe>, ["~> 0.3"])
  end
end

