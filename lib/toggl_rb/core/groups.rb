# frozen_string_literal: true

module TogglRb
  module Core
    class Groups
      include EndpointDSL
      include RequestHelpers

      request_method :get
      request_path "organizations/%<organization_id>s/workspaces/%<workspace_id>s/groups"
      def list(organization_id:, workspace_id:)
        resource_path = format(request_path, workspace_id: workspace_id, organization_id: organization_id)

        send_request(request_method, resource_path).body_json
      end

      private

      def connection
        TogglRb::Core.connection
      end
    end
  end
end
