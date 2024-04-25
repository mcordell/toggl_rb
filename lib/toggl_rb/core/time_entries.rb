# frozen_string_literal: true

module TogglRb
  module Core
    # Time Entries endpoint
    # @see https://engineering.toggl.com/docs/api/time_entries
    class TimeEntries
      include EndpointDSL
      include RequestHelpers

      request_method :get
      request_path "me/time_entries"
      query_param :since, Integer,
                  description: "Get entries modified since this date using UNIX timestamp, including deleted ones."
      query_param :before, String,
                  description: "Get entries with start time, before given date (YYYY-MM-DD) or with time in " \
                               "RFC3339 format."
      query_param :start_date, String,
                  description: "Get entries with start time, from start_date YYYY-MM-DD or with time in RFC3339 " \
                               "format. To be used with end_date."
      query_param :end_date, String,
                  description: "Get entries with start time, until end_date YYYY-MM-DD or with time in RFC3339 " \
                               "format. To be used with start_date."
      query_param :meta, "boolean", description: "Should the response contain data for meta entities"
      query_param :include_sharing, "boolean", description: "Include sharing details in the response"
      def list(query_params = {})
        resource_path = build_query_params(query_params).build_url(request_path)
        send_request(request_method, resource_path).body_json
      end


      request_method :get
      request_path "me/time_entries/current"
      def current
        send_request(request_method, request_path).body_json
      end

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
      def create(workspace_id, params)
        params[:wid] = workspace_id.to_i
        resource_path = format(request_path, workspace_id: workspace_id)

        send_request(request_method, resource_path, params).body_json
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

      def connection
        TogglRb::Core.connection
      end
    end
  end
end

