# frozen_string_literal: true

require "forwardable"
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
  class Error < StandardError; end

  def self.debug_logging?
    config.debug_logging?
  end

  def self.config
    @config ||= Config.new
  end

  def self.client
    @client ||= Client.new
  end

  def self.operation(operations = [])
    JSONPatch.new(operations)
  end
end

