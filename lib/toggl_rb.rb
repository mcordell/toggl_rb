# frozen_string_literal: true

require "forwardable"
require_relative "toggl_rb/request"
require_relative "toggl_rb/endpoint_dsl"
require_relative "toggl_rb/response"
require_relative "toggl_rb/connection"
require_relative "toggl_rb/client"
require_relative "toggl_rb/config"
require_relative "toggl_rb/param"
require_relative "toggl_rb/params"
require_relative "toggl_rb/query_params"
require_relative "toggl_rb/reports"
require_relative "toggl_rb/core"
require_relative "toggl_rb/version"
require_relative "toggl_rb/json_patch"

module TogglRb
  # A custom error class for the TogglRb module, inheriting from StandardError.
  class Error < StandardError; end

  # Check if debug logging is enabled in the configuration.
  # @return [Boolean] true if debug logging is enabled, false otherwise
  def self.debug_logging?
    config.debug_logging?
  end

  # Access or initialize the configuration for the TogglRb module.
  # This method ensures that there is only one instance of Config throughout the application lifecycle.
  # @return [Config] the configuration instance
  def self.config
    @config ||= Config.new
  end

  # Access or initialize the client used to interact with the API.
  # This method ensures that there is only one instance of Client throughout the application lifecycle.
  # @return [Client] the client instance
  def self.client
    @client ||= Client.new
  end

  # Create a new JSONPatch object initialized with a list of operations.
  # This method is used for generating a JSON patch based on the provided operations.
  # @param operations [Array<Hash>] an array of operation hashes for the JSON patch
  # @return [JSONPatch] the JSONPatch object initialized with the given operations
  def self.operation(operations = [])
    JSONPatch.new(operations)
  end
end
