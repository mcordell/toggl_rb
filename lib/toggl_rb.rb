# frozen_string_literal: true

require_relative "toggl_rb/config"
require_relative "toggl_rb/version"

module TogglRb
  class Error < StandardError; end
  # Your code goes here...

  def self.debug_logging?
    config.debug_logging?
  end

  def self.config
    @config ||= Config.new
  end
end

