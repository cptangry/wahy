# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "./lib/wahy/version.rb"

Gem::Specification.new do |spec|
  spec.name          = "wahy"
  spec.version       = Wahy::VERSION
  spec.authors       = ["Gökhan Çağlar"]
  spec.email         = ["caglar.gokhan@gmail.com"]

  spec.summary       = %q{You can read Quran's scriptures or signs from terminal}
  spec.description   = %q{This gem show user Quran's scriptures and signs in English and also in Turkish with sign number and colored}
  spec.homepage      = "https://github.com/cptangry/wahy"
  spec.license       = "MIT"
  spec.executables   = "wahy"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org/"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "./lib/"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'nokogiri', '~> 1.8'
  spec.add_development_dependency 'colorize', '~> 0.8.1'
end
