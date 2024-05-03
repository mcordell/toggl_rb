# frozen_string_literal: true

module TogglRb
  # Core API holds the commonly used endpoints. While Toggl does not call this
  # "core", it is a namespace to differentiate it from Reporting
  module Core
    require_relative "core/base"
    require_relative "core/groups"
    require_relative "core/projects"
    require_relative "core/time_entries"
    require_relative "core/users"
    require_relative "core/me"
    require_relative "core/workspaces"
  end
end
