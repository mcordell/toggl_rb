# frozen_string_literal: true

module TogglRb
  # Connection represents a connection to an API grouping on toggl's side (i.e.
  # the core API or the reports API) this class is a thin wrapper around
  # Faraday's connection
  class Connection
    extend Forwardable

    def initialize(url)
      @faraday_connection = Faraday.new(url)
      setup_connection!
    end

    def setup_auth!
      faraday_connection.set_basic_auth(config.username, config.password) if config.basic_auth?
      faraday_connection.set_basic_auth(config.api_token, TogglRb::Config::API_TOKEN_PASSWORD) if config.api_token?
    end

    def_delegators(:faraday_connection, *TogglRb::EndpointDSL::ClassMethods::ALLOWED_METHOD_TYPES)
    def_delegators(:faraday_connection, :headers)

    private

    def setup_connection!
      setup_auth!
      faraday_connection.headers["Content-Type"] = "application/json"
      faraday_connection.headers["Accept"] = "application/json"
    end

    # @return [TogglRb::Config]
    def config
      TogglRb.config
    end

    attr_reader :faraday_connection
  end
end
