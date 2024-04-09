# frozen_string_literal: true

module TogglRb
  # Config class stores global configuration for the TogglRb gem
  class Config
    attr_accessor :username, :password, :api_token
    attr_writer :debug_logging

    API_TOKEN_PASSWORD = "api_token"

    # Whether username and password are set within this config in order to use basic auth. Basic auth is necessary for
    # reports API.
    # @return [Boolean] whether username and password exist
    def basic_auth?
      !!(username && password)
    end

    def api_token?
      !!api_token
    end

    # @return [Boolean] whether to log debug messages
    def debug_logging
      !!@debug_logging || ENV.fetch("TOGGL_RB_DEBUG_LOG", nil) || false
    end

    alias debug_logging? debug_logging
  end
end
