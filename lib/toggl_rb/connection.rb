# frozen_string_literal: true

module TogglRb
  # Connection represents a connection to an API grouping on toggl's side, such as
  # the core API or the reports API. This class is a thin wrapper around Faraday's
  # connection, facilitating the setup and configuration of HTTP requests specific
  # to Toggl's APIs.
  class Connection
    extend Forwardable

    URLS = {
      core: { url: "https://api.track.toggl.com/api/v9" },
      reports: { url: "https://api.track.toggl.com/reports/api/v3/" }
    }.freeze

    # @!attribute [r] api_token
    #   @return [String, nil] the API token for making requests
    attr_reader :api_token

    # @return [Connection] returns a connection setup with the core URL
    def self.core_connection
      new(URLS.dig(:core, :url))
    end

    # @return [Connection] returns a connection setup with the reports URL
    def self.reports_connection
      new(URLS.dig(:reports, :url))
    end

    # Initializes a new Connection object and sets up the HTTP connection with Faraday.
    # @param url [String] the base URL for the Toggl API
    def initialize(url)
      @faraday_connection = Faraday.new(url)
      setup_connection!
    end

    # @param api_token [String] the API token to set on this instance and use for requests
    def api_token=(api_token)
      @api_token = api_token
      faraday_connection.set_basic_auth(api_token, TogglRb::Config::API_TOKEN_PASSWORD)
    end

    # Configures authentication for the Faraday connection based on the TogglRb
    # configuration. It uses either basic authentication with username and
    # password or an API token.
    # @return [Connection] returns self
    def setup_auth!
      faraday_connection.set_basic_auth(config.username, config.password) if config.basic_auth?
      faraday_connection.set_basic_auth(config.api_token, TogglRb::Config::API_TOKEN_PASSWORD) if config.api_token?
      self
    end

    # Delegates specified method calls to the Faraday connection.
    # Currently, it delegates allowed HTTP method types (like :get, :post, etc.) and
    # the :headers method from Faraday::Connection.
    def_delegators :faraday_connection, *TogglRb::EndpointDSL::ClassMethods::ALLOWED_METHOD_TYPES
    def_delegators :faraday_connection, :headers

    private

    # Configures the Faraday connection with default headers and authentication.
    # This private method is called during the initialization process.
    # @return [Connection] returns self
    def setup_connection!
      setup_auth!
      faraday_connection.headers["Content-Type"] = "application/json"
      faraday_connection.headers["Accept"] = "application/json"
      self
    end

    # Provides access to the module-wide configuration settings.
    # @return [TogglRb::Config] the configuration instance used for the connection setup
    def config
      TogglRb.config
    end

    # @!attribute [r] faraday_connection
    #   @return [Faraday::Connection] the Faraday connection instance used for HTTP requests
    attr_reader :faraday_connection
  end
end
