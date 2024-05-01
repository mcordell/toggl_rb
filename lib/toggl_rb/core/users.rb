# frozen_string_literal: true

module TogglRb
  module Core
    class Users < Base
      request_method :get
      request_path "workspaces/%<workspace_id>s/users"
      def list(workspace_id)
        resource_path = format(request_path, workspace_id: workspace_id)

        send_request(request_method, resource_path, nil).body_json
      end
    end
  end
end
