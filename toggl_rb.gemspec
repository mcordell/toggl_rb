# frozen_string_literal: true

require_relative "lib/toggl_rb/version"

Gem::Specification.new do |spec|
  spec.name = "toggl_rb"
  spec.version = TogglRb::VERSION
  spec.authors = ["Michael Cordell"]
  spec.email = ["mike@mikecordell.com"]

  spec.summary = "A toggl rb API client supporting V9"
  spec.description = "A toggl rb API client supporting V9 version of the main API and V3 of the reporting API"
  spec.homepage = "https://github.com/mcordell/toggl_rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://mcordell.github.io/toggl_rb/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 2.9"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
