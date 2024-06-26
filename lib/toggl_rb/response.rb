# frozen_string_literal: true

module TogglRb
  # The Response class wraps HTTP responses received from the Toggl API and provides helper methods
  # to interact with the data returned in a convenient manner.
  class Response
    extend Forwardable

    # @!attribute [rw] request
    #   @return [TogglRb::Request] request corresponding to this response
    attr_accessor(:request)

    # The HTTP header key used to fetch the next row number for paginated responses.
    NEXT_ROW_NUMBER_HEADER = "x-next-row-number"

    # Initializes a new Response object wrapping a Faraday response.
    # @param faraday_response [Faraday::Response] the HTTP response object from Faraday
    def initialize(faraday_response)
      @faraday_response = faraday_response
    end

    # Returns the parsed JSON body
    # @return [Hash] the parsed JSON body as a hash
    def body_json
      @body_json ||= JSON.parse(@faraday_response.body)
    end

    # Checks if there are more rows to fetch
    # @return [Boolean] true if there is a next row number, false otherwise
    def more?
      !!next_row_number
    end

    # Retrieves the next row number from the response headers if available.
    # @return [String, nil] the next row number, or nil if not present
    def next_row_number
      @faraday_response.headers[NEXT_ROW_NUMBER_HEADER]
    end

    # @return [TogglRb::Request] request for the next page of results
    def next_page_request
      raise TogglRb::Error, "Request not pagninatable" unless request.params.is_a?(Params)

      request.params.first_row_number = next_row_number if more?
      request
    end

    # Delegates the status method call directly to the Faraday response object.
    # @!method status
    # @return [Integer] the HTTP status code of the response
    # @!method success?
    # @return [Boolean] whether the request successful according to Farday response success
    def_delegators :@faraday_response, :status, :success?
  end
end
