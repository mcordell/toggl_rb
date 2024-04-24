# frozen_string_literal: true

module TogglRb
  module Core
    class Workspaces
      include EndpointDSL
      include RequestHelpers

      request_method :get
      request_path "workspaces/%<workspace_id>s"
      # @param workspace_id [Integer, String] the workspace id to get
      def get(workspace_id)
        send_request(request_method, format(request_path, workspace_id: workspace_id)).body_json
      end

      private

      # @return [TogglRb::Connection] cconnection for this endpoint
      def connection
        TogglRb::Core.connection
      end
    end
  end
end
