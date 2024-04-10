# frozen_string_literal: true

module TogglRb
  module Core
    class TimeEntries
      include EndpointDSL

      request_method :patch
      request_path "workspaces/%<workspace_id>s/time_entries/%<time_entry_ids>s"
      # @param workspace_id [String|Integer] the workspace ID
      # @param time_entries [Array<Integer>] the IDs of the task entries to update
      # @param operation    [TogglRb::JSONPatch] the operation to apply to the time entries
      def patch(workspace_id, time_entries, operation)
        resource_path = format(request_path, workspace_id: workspace_id, time_entry_ids: time_entries.join(","))

        send_request(request_method, resource_path, operation).body_json
      end

      private

      def send_request(request_method, resource_path, body)
        params = body.to_json unless body.is_a?(String)
        TogglRb::Response.new(connection.send(request_method, resource_path, params))
      end

      def connection
        TogglRb::Core.connection
      end
    end
  end
end
