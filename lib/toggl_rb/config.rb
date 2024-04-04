# frozen_string_literal: true

module TogglRb
  # Config class stores global configuration for the TogglRb gem
  class Config
    attr_writer :debug_logging

    # @return [Boolean] whether to log debug messages
    def debug_logging
      !!@debug_logging || ENV.fetch("TOGGL_RB_DEBUG_LOG", nil) || false
    end

    alias debug_logging? debug_logging
  end
end
