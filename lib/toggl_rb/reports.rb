# frozen_string_literal: true

module TogglRb
  # Reports provides functionality for leveraging Toggl Data Structure to generate customized reports via
  # the Toggl API.
  module Reports
    require_relative "reports/base"
    require_relative "reports/detailed"
    require_relative "reports/summary"
  end
end
