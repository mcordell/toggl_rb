# frozen_string_literal: true

module TogglRb
  class Response
    extend Forwardable
    NEXT_ROW_NUMBER_HEADER = "x-next-row-number"

    def initialize(farady_response)
      @farady_response = farady_response
    end

    def body_json
      @body_json ||= JSON.parse(@farady_response.body)
    end

    def more?
      !!next_row_number
    end

    def next_row_number
      @farady_response.headers[NEXT_ROW_NUMBER_HEADER]
    end

    def_delegators :@farady_response, :status
  end
end
