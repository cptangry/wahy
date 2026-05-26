# frozen_string_literal: true

require_relative "lib/wahy/version"

Gem::Specification.new do |spec|
  spec.name = "wahy"
  spec.version = Wahy::VERSION
  spec.authors = ["cptangry"]
  spec.email = ["caglar.gokhan@gmail.com"]

  spec.summary       = "A CLI tool and library to query the Holy Quran in TR/ENG."
  spec.description   = "Query and read the Holy Quran chapters and verses in the terminal with colored output. Includes both English and Turkish support."
  spec.homepage      = "https://github.com/cptangry/wahy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 4.0.2"
  # Uncomment the line below to require MFA for gem pushes.
  # This helps protect your gem from supply chain attacks by ensuring
  # no one can publish a new version without multi-factor authentication.
  # See: https://guides.rubygems.org/mfa-requirement-opt-in/
  # spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["wahy"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 4.0.12"
  spec.add_development_dependency 'rake', '~> 13.4'
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_runtime_dependency 'nokogiri', '~> 1.8'
  spec.add_runtime_dependency 'colorize', '~> 0.8.1'

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://guides.rubygems.org/make-your-own-gem/
end
