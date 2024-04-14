# frozen_string_literal: true

module TogglRb
  module Core
    class Users
      include EndpointDSL

      request_method :get
      request_path "workspaces/%<workspace_id>s/users"
      def list(workspace_id)
        resource_path = format(request_path, workspace_id: workspace_id)

        send_request(request_method, resource_path, nil).body_json
      end

      private

      def send_request(request_method, resource_path, body)
        if body.nil?
          TogglRb::Response.new(connection.send(request_method, resource_path))
        else
          params = body.to_json unless body.is_a?(String)
          TogglRb::Response.new(connection.send(request_method, resource_path, params))
        end
      end

      def connection
        TogglRb::Core.connection
      end
    end
  end
end
