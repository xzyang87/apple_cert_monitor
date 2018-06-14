
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "apple_cert_monitor/version"

Gem::Specification.new do |spec|
  spec.name          = "apple_cert_monitor"
  spec.version       = AppleCertMonitor::VERSION
  spec.authors       = ["Xiaozhu Yang"]
  spec.email         = ["xzyang@thoughtworks.com"]

  spec.summary       = %q{Check for expiration}
  spec.description   = %q{What Apple Developer Account Client do is to monitor all the expiring and expired certificates and provising profiles in all teams of an Apple developer account.}
  spec.homepage      = "https://github.com/xzyang87/apple-developer-account-client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.3'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-core"

  spec.add_runtime_dependency "thor", "~>0.20"
  spec.add_dependency "fastlane", "~>2.91"
end
