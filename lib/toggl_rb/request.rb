# frozen_string_literal: true

module TogglRb
  module RequestHelpers
    # @param request_method [Symbol] HTTP request method, :get, :post, etc
    # @param request_method [String] endpoint path on the API
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

    # @return [TogglRb::Connection]
    def connection
      raise "Connection is not implemented"
    end
  end

  class Request
    # @param connection [TogglRb::Connection] API connection to use for this request
    # @param request_method [Symbol] HTTP request method, :get, :post, etc
    # @param request_method [String] endpoint path on the API
    # @param body [Mixed] the body or request params
    # @return [TogglRb::Response]
    def self.send_request(connection, request_method, resource_path, body = nil)
      new(connection).send_request(request_method, resource_path, body)
    end

    # @param connection [TogglRb::Connection] API connection for making the request
    def initialize(connection)
      @connection = connection
    end

    # @return [TogglRb::Response] the response for this request
    def send_request(request_method, resource_path, body = nil)
      rsp = if body.nil?
              connection.send(request_method, resource_path)
            elsif request_method == :get
              connection.get(resource_path)
            else
              params = body.to_json unless body.is_a?(String)
              connection.send(request_method, resource_path, params)
            end
      TogglRb::Response.new(rsp)
    end

    private

    # @!attribute [r] connection
    #   @return [TogglRb::Connection] API connection used for making this request
    attr_reader :connection
  end
end
