# frozen_string_literal: true

module TogglRb
  # RequestHelpers provides helper methods for making requests from API endpoints
  module RequestHelpers
    # @param request_method [Symbol] HTTP request method, :get, :post, etc
    # @param resource_path [String] endpoint path on the API
    # @param body [Mixed] the body or request params
    # @return [TogglRb::Response]
    def send_request(request_method, resource_path, body = nil)
      Request.send_request(
        connection,
        request_method,
        resource_path,
        body
      )
    end

    private

    # @param response [TogglRb::Response]
    def request_all(response)
      all_items = response.body_json

      while response.more?
        response = response.next_page_request.execute
        all_items += response.body_json
      end

      all_items
    end

    # @return [TogglRb::Connection]
    def connection
      raise "Connection is not implemented"
    end
  end

  # Request represents a single request for an API. It stores the relevant
  # details and dispatches the request to the connection.
  # @see TogglRb::Connection
  class Request
    # @param connection [TogglRb::Connection] API connection to use for this request
    # @param request_method [Symbol] HTTP request method, :get, :post, etc
    # @param resource_path [String] endpoint path on the API
    # @param body [Mixed] the body or request params
    # @return [TogglRb::Response]
    def self.send_request(connection, request_method, resource_path, body = nil)
      new(connection).send_request(request_method, resource_path, body)
    end

    # @!attribute [rw] params
    #   @return [TogglRb::Params] Params for this request
    # @!attribute [rw] request_method
    #   @return [Symbol] request HTTP method
    # @!attribute [rw] resource_path
    #   @return [String] the resource_path
    attr_accessor(:params, :request_method, :resource_path)

    # @param connection [TogglRb::Connection] API connection for making the request
    def initialize(connection)
      @connection = connection
    end

    # @return [TogglRb::Response] the response for this request
    def execute
      send_request(request_method, resource_path, params)
    end

    # @param request_method [Symbol] HTTP request method, :get, :post, etc
    # @param resource_path [String] endpoint path on the API
    # @param body [Mixed] the body or request params
    # @return [TogglRb::Response] the response for this request
    # rubocop:disable Metrics/MethodLength
    def send_request(req_method, path, body = nil)
      self.request_method ||= req_method
      self.resource_path ||= path
      log_request
      rsp = if body.nil?
              connection.send(req_method, path)
            else
              self.params = build_params(body)
              connection.send(req_method, path, params.to_json)
            end
      TogglRb::Response.new(rsp).tap do |r|
        r.request = self
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    # @param body [Params, JSONPatch, nil, Hash] the body to setup
    # @raise [ArgumentError] when body is an unknown type
    # @return [Params, JSONPatch] description
    def build_params(body)
      return body if body.is_a?(Params) || body.is_a?(JSONPatch)

      body = JSON.parse(body) if body.is_a? String
      return Params.new.tap { |p| p.request_params = body } if body.is_a?(Hash)

      raise ArgumentError, "Unknown body type #{body}"
    end

    def log_request
      return unless TogglRb.debug_logging?

      TogglRb.config.logger.info("#{request_method.to_s.upcase} #{resource_path}")
    end

    # @!attribute [r] connection
    #   @return [TogglRb::Connection] API connection used for making this request
    attr_reader :connection
  end
end
