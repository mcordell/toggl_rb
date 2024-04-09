# frozen_string_literal: true

require "faraday"

module TogglRb
  # Config class stores global configuration for the TogglRb gem
  class Client
    attr_reader :base_connection, :reports_connection

    URLS = {
      base: { url: "https://api.track.toggl.com/api/v9" },
      reports: { url: "https://api.track.toggl.com/reports/api/v3/" }
    }.freeze

    def initialize
      @base_connection = Faraday.new(URLS.dig(:base, :url))
      @reports_connection = Faraday.new(URLS.dig(:reports, :url)).tap do |fc|
        fc.set_basic_auth(config.username, config.password) if config.basic_auth?
        fc.set_basic_auth(config.api_token, TogglRb::Config::API_TOKEN_PASSWORD) if config.api_token?
        fc.headers["Content-Type"] = "application/json"
        fc.headers["Accept"] = "application/json"
      end
    end

    private

    # @return [TogglRb::Config]
    def config
      TogglRb.config
    end
  end
end
