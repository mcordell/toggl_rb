# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "spec/"
  if ENV["CI"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end

require "toggl_rb"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = false
  # Filter sensitive information
  config.filter_sensitive_data("<TOGGL_API_TOKEN>") { ENV.fetch("TOGGL_API_TOKEN", nil) }
  config.filter_sensitive_data("<TOGGL_WORKSPACE_ID>") { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }
  config.filter_sensitive_data("<TOGGL_BASIC_AUTH>") { ENV.fetch("TOGGL_BASIC_AUTH", nil) }
  config.filter_sensitive_data("<TOGGL_USER_EMAIL>") { ENV.fetch("TOGGL_EMAIL", nil) }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
