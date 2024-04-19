# frozen_string_literal: true

module TogglRb
  # Config class stores global configuration settings for the TogglRb gem.
  class Config
    # @!attribute [rw] username
    #   @return [String, nil] the username for Toggl API access, used with password for basic auth
    # @!attribute [rw] password
    #   @return [String, nil] the password for Toggl API access, used with username for basic auth
    # @!attribute [rw] api_token
    #   @return [String, nil] the API token for Toggl API access, used for token-based authentication
    attr_accessor :username, :password, :api_token

    # @!attribute [w] debug_logging
    #   @return [void] sets whether debugging messages should be logged
    attr_writer :debug_logging

    # Constant used to represent the password when using API token authentication.
    API_TOKEN_PASSWORD = "api_token"

    # Checks if both username and password are set for using basic authentication.
    # @return [Boolean] true if both username and password are set, otherwise false.
    def basic_auth?
      !!(username && password)
    end

    # Checks if an API token is set for token-based authentication.
    # @return [Boolean] true if an API token is set, otherwise false.
    def api_token?
      !!api_token
    end

    # Determines whether to log debug messages based on the instance setting or an environment variable.
    # @return [Boolean] true if debugging is enabled, otherwise false.
    def debug_logging
      !!@debug_logging || !!ENV.fetch("TOGGL_RB_DEBUG_LOG", nil) || false
    end

    # Alias for the debug_logging method to query debug logging status.
    alias debug_logging? debug_logging
  end
end
