# frozen_string_literal: true

require "json"

module TogglRb
  module Core
    class Me
      include EndpointDSL

      request_method :get
      request_path "me"
      query_param :with_related_data, "Boolean", description: "whether to include related data"
      # @param with_related_data [Boolean] whether to include related data
      def get(with_related_data: false)
        resource_path = with_related_data ? "#{request_path}?with_related_data=true" : request_path
        send_request(request_method, resource_path).body_json
      end

      request_method :get
      request_path "me/workspaces"
      query_param :since, Date,
                  description: "Retrieve workspaces created/modified/deleted since this date using UNIX timestamp, " \
                               "including the dates a workspace member got added, removed or updated in the workspace."
      def workspaces(query_params = {})
        # TODO: implement since query_param
        query_params["since"]
        send_request(request_method, request_path).body_json
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
