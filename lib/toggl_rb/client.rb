# frozen_string_literal: true

require "faraday"

module TogglRb
  # Config class stores global configuration for the TogglRb gem
  class Client
    attr_reader :core_connection, :reports_connection

    def initialize
      @core_connection = Connection.core_connection
      @reports_connection = Connection.reports_connection
    end
  end
end
