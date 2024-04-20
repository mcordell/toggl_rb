# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in toggl_rb.gemspec
gemspec

gem "rake", "~> 13.0"

group :test do
  gem "rspec", "~> 3.0"
  gem "simplecov", require: false
  gem "simplecov-lcov", "~> 0.7.0", require: false
  gem "vcr", ">= 6.2"
end

group :development do
  gem "rbs", "~> 3.4", require: false
  gem "rubocop", "~> 1.21"
  gem "rubocop-performance", "~> 1.21", require: false
  gem "rubocop-rspec", "~> 2.29", require: false
  gem "steep", "~> 1.6", require: false
  gem "yard", "~> 0.9.36"
end

group :ci do
  gem "code-scanning-rubocop", "~> 0.6.1"
end
