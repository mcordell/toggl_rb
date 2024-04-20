# frozen_string_literal: true

require "faraday"

module TogglRb
  # Config class stores global configuration for the TogglRb gem
  class Client
    attr_reader :core_connection, :reports_connection

    URLS = {
      core: { url: "https://api.track.toggl.com/api/v9" },
      reports: { url: "https://api.track.toggl.com/reports/api/v3/" }
    }.freeze

    def initialize
      @core_connection = Connection.new(URLS.dig(:core, :url))
      @reports_connection = Connection.new(URLS.dig(:reports, :url))
    end
  end
end
