# frozen_string_literal: true

module TogglRb
  class QueryParams < Params
    def build_url(base_path)
      return base_path if request_params.empty?

      uri = URI.parse(base_path)
      uri.query = URI.encode_www_form(request_params)
      uri.to_s
    end
  end
end
