# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/serviceman/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-serviceman"
  spec.version       = Capistrano::Serviceman::VERSION
  spec.authors       = ["Jakub Hozak"]
  spec.email         = ["jakub.hozak@gmail.com"]

  spec.summary       = %q{Deploy Pumas by Systemd and watch them with Monit.}
  spec.description   = %q{Capistrano Serviceman helps you to manage Puma and Sidekiq
                          processes using Systemd and watch them by Monit. Configuration
                          is driven by templates directory structure, making it very
                          easy to adjust all to your liking.}
  spec.homepage      = "https://github.com/sinfin/capistrano-serviceman"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "capistrano", "~> 3.8.0"
  # spec.add_development_dependency "bundler", "~> 1.14"
  # spec.add_development_dependency "rake", "~> 10.0"
  # spec.add_development_dependency "minitest", "~> 5.0"
end
