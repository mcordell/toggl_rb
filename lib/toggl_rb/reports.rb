# frozen_string_literal: true

module TogglRb
  # @class Reports provides functionality for leveraging Toggl Data Structure to generate customized reports via the
  #                reports from the Toggl API.
  module Reports
    require_relative "reports/detailed"
    require_relative "reports/summary"

    def self.connection
      TogglRb.client.reports_connection
    end
  end
end
