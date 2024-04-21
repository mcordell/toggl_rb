# frozen_string_literal: true

require "json"

module TogglRb
  module Core
    class Me
      include EndpointDSL
      include RequestHelpers

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

      def connection
        TogglRb::Core.connection
      end
    end
  end
end
