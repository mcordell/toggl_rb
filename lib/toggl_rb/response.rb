# frozen_string_literal: true

module TogglRb
  class Response
    extend Forwardable

    def initialize(farady_response)
      @farady_response = farady_response
    end

    def body_json
      @body_json ||= JSON.parse(@farady_response.body)
    end

    def_delegators :@farady_response, :status
  end
end
