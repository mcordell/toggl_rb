# frozen_string_literal: true

require "faraday"

module TogglRb
  # Client holds connections to APIs for re-use
  class Client
    attr_reader :core_connection, :reports_connection

    def initialize
      @core_connection = Connection.core_connection
      @reports_connection = Connection.reports_connection
    end
  end
end
