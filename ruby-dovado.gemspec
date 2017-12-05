# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dovado/version'

ruby_2_3_0_plus = Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.3.0")

Gem::Specification.new do |spec|
  spec.name          = "ruby-dovado"
  spec.version       = Dovado::VERSION
  spec.authors       = ["Jan Lindblom"]
  spec.email         = ["janlindblom@fastmail.fm"]

  spec.summary       = %q{Dovado Router API for Ruby.}
  spec.homepage      = "https://bitbucket.org/janlindblom/ruby-dovado"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "celluloid", "~> 0.17"
  spec.add_runtime_dependency "thread_safe", "~> 0.3"
  if ruby_2_3_0_plus
    spec.add_runtime_dependency "net-telnet", "~> 0.1"
  end
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "yard", "~> 0.8"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "dotenv", "~> 2.0.2"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.2.3"
  spec.add_development_dependency "simplecov", "~> 0.11.2"
  spec.add_development_dependency "simplecov-rcov", "~> 0.2.3"
end
