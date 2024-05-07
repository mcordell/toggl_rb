# frozen_string_literal: true

module TogglRb
  # RequestHelpers provides helper methods for making requests from API endpoints
  module RequestHelpers
    # @param request_method [Symbol] HTTP request method, :get, :post, etc
    # @param resource_path [String] endpoint path on the API
    # @param body [Mixed] the body or request params
    # @return [TogglRb::Response]
    def send_request(request_method, resource_path, body = nil, request_options = {})
      handle_response(Request.send_request(
                        connection,
                        request_method,
                        resource_path,
                        body,
                        request_options
                      ))
    end

    private

    # @param response [TogglRb::Response]
    # @return [Array<TogglRb::Response>]
    def request_all(response)
      all_items = [response]

      while response.more?
        response = response.next_page_request.execute
        all_items.push(response)
      end

      all_items
    end

    # @return [TogglRb::Connection]
    def connection
      raise "Connection is not implemented"
    end

    def handle_response(response)
      if response.success?
        response = request_all(response) if response.request.get_all?
        return result(response)
      end

      handle_error(response)
    end

    def handle_error(response)
      response.body_json
    end

    def result(response)
      return response_array(response) if response.is_a?(Array)
      return true if response.request.delete?
      return response if response.return_responses?
      return response.objects if response.can_return_ruby_objects?

      response.body_json
    end

    def response_array(array_response)
      array_response.reduce([]) do |out, r|
        response = result(r)
        response.is_a?(Array) ? out.concat(response) : out.push(response)
      end
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
    def self.send_request(connection, request_method, resource_path, body = nil, request_options = {})
      r = new(connection)
      r.request_options = request_options
      r.send_request(request_method, resource_path, body)
    end

    # @!attribute [rw] params
    #   @return [TogglRb::Params] Params for this request
    # @!attribute [rw] request_method
    #   @return [Symbol] request HTTP method
    # @!attribute [rw] resource_path
    #   @return [String] the resource_path
    attr_accessor(:params, :request_method, :resource_path)

    attr_writer(:request_options)

    # @param connection [TogglRb::Connection] API connection for making the request
    def initialize(connection)
      @connection = connection
    end

    # Executes this request with set variables rather
    # @return [Object] returns the result of this request based on result_format
    def execute
      send_request(request_method, resource_path, params)
    end
    # rubocop:disable Metrics/MethodLength

    # @param req_method [Symbol] HTTP request method, :get, :post, etc
    # @param path [String] endpoint path on the API
    # @param body [Mixed] the body or request params
    # @return [Object] mixed return value based on result format
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

    # @return [Boolean] whether this is a delete request
    def delete?
      request_method == :delete
    end

    # rubocop:disable Naming/AccessorMethodName

    # @return [Boolean] whether to get all objects for this request
    def get_all?
      request_options.fetch(:get_all, false)
    end
    # rubocop:enable Naming/AccessorMethodName

    # @return [:basic_types, :response, :objects] the format that this request's response should be returned in
    def result_format
      result_option || TogglRb.config.result_format
    end

    # @return [Class, nil]
    def result_class
      request_options[:result_class]
    end

    private

    def result_option
      opt = request_options[:result_format]
      return nil unless Config::RESULT_FORMATS.include?(opt)

      opt
    end

    # @return [Hash] options for this request
    def request_options
      @request_options || {}
    end

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
