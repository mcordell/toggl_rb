# frozen_string_literal: true

module TogglRb
  module Core
    require_relative "core/groups"
    require_relative "core/projects"
    require_relative "core/time_entries"
    require_relative "core/users"
    require_relative "core/me"
    require_relative "core/workspaces"

    def self.connection
      TogglRb.client.core_connection
    end
  end
end
