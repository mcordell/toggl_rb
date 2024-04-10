# frozen_string_literal: true

module TogglRb
  module Core
    require_relative "core/time_entries"
    require_relative "core/me"

    def self.connection
      TogglRb.client.core_connection
    end
  end
end