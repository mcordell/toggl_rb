# frozen_string_literal: true

require "json"

module TogglRb
  module Core
    class Me
      include EndpointDSL

      request_method :get
      request_path "me"
      def get(with_related_data: false)
        resource_path = with_related_data ? "#{request_path}?with_related_data=true" : request_path
        send_request(request_method, resource_path).body_json
      end

      private

      def send_request(request_method, resource_path, body = nil)
        rsp = if request_method == :get
                connection.get(resource_path)
              else
                params = body.to_json unless body.is_a?(String)
                connection.send(request_method, resource_path, params.to_json)
              end
        TogglRb::Response.new(rsp)
      end

      def connection
        TogglRb::Core.connection
      end
    end
  end
end
