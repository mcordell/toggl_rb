# frozen_string_literal: true

module TogglRb
  module Core
    class TimeEntries
      include EndpointDSL

      request_method :post
      request_path "workspaces/%<workspace_id>s/time_entries"
      param :billable, "Boolean", optional: true, default: false,
                                  description: "Whether the time entry is marked as billable."
      param :created_with, String, required: true,
                                   description: "Identifies the service/application used to create it."
      param :description, String, optional: true, description: "Time entry description."
      param :duration, Integer, required: true, description: "Duration in seconds; negative for running entries."
      param :pid, Integer, optional: true, description: "Project ID (legacy field)."
      param :project_id, Integer, optional: true, description: "Project ID."
      param :shared_with_user_ids, "Array<Integer>", optional: true,
                                                     description: "User IDs to share this time entry with."
      param :start, Time, required: true, description: "Start time in UTC. Format: 2006-01-02T15:04:05Z."
      param :start_date, Date, optional: true,
                               description: "Takes precedence over the date part of 'start'. Format: 2006-11-07."
      param :stop, Time, optional: true, description: "Stop time in UTC."
      param :tag_action, String, optional: true, description: "Used when updating; can be 'add' or 'delete'."
      param :tag_ids, "Array<Integer>", optional: true, description: "Tag IDs to add/remove."
      param :tags, "Array<String>", optional: true,
                                    description: "Tag names to add/remove; creates tag if it doesn't exist."
      param :task_id, Integer, optional: true, description: "Task ID."
      param :user_id, Integer, optional: true, description: "Time Entry creator ID; uses requester ID if omitted."
      param :workspace_id, Integer, required: true, description: "Workspace ID."
      # NOTE: tid is a legacy field for Task ID.
      # Note: uid is a legacy field for Time Entry creator ID.
      # NOTE: duronly is deprecated and can be ignored.
      # NOTE: wid is a legacy param for Workspace ID which will be populated with the passed argument
      def create(workspace_id, time_entry_attributes)
        time_entry_attributes[:wid] = workspace_id.to_i
        resource_path = format(request_path, workspace_id: workspace_id)

        send_request(request_method, resource_path, time_entry_attributes).body_json
      end

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
