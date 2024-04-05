# frozen_string_literal: true

require "faraday"

module TogglRb
  # Config class stores global configuration for the TogglRb gem
  class Client
    attr_reader :base_connection

    URLS = {
      base: { url: "https://api.track.toggl.com/api/v9" }
    }.freeze

    def initialize
      @base_connection = Faraday.new(URLS.dig(:base, :url))
    end
  end
end

