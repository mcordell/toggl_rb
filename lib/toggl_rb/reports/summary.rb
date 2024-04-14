# frozen_string_literal: true

module TogglRb
  module Reports
    class Summary
      include TogglRb::EndpointDSL

      request_path "workspace/%<workspace_id>s/summary/time_entries"
      request_method :post
      param :billable, "Boolean", optional: true, description: "Whether the time entry is set as billable."
      param :client_ids, "Array<Integer>", optional: true,
                                           description: "Client IDs, use [null] to filter records with no clients."
      param :description, String, optional: true, description: "Description of the filter."
      param :distinguish_rates, "Boolean", optional: true, default: false,
                                           description: "Create new subgroups for each rate."
      param :end_date, String,
            description: "End date, format example time.DateOnly, must be greater than start date."
      param :group_ids, "Array<Integer>", optional: true, description: "Group IDs for filtering."
      param :grouping, String, optional: true, description: "Grouping option."
      param :include_time_entry_ids, "Boolean", optional: true, default: false,
                                                description: "Include time entry IDs in results."
      param :max_duration_seconds, Integer, optional: true, description: "Max duration in seconds."
      param :min_duration_seconds, Integer, optional: true, description: "Min duration in seconds."
      param :project_ids, "Array<Integer>", optional: true, description: "Project IDs, use [null] for no projects."
      param :rounding, Integer, optional: true, description: "Rounding method, default from workspace settings."
      param :rounding_minutes, Integer, optional: true,
                                        description: "Rounding minutes, should be specific values."
      param :start_date, String, required: true,
                                 description: "Start date, format example time.DateOnly, less than end date."
      param :sub_grouping, String, optional: true, description: "SubGrouping option."
      param :tag_ids, "Array<Integer>", optional: true, description: "Tag IDs, use [null] for no tags."
      param :task_ids, "Array<Integer>", optional: true, description: "Task IDs, use [null] for no tasks."
      param :time_entry_ids, "Array<Integer>", description: "Filter by time entries, for compatibility."
      param :user_ids, "Array<Integer>", optional: true, description: "User IDs for filtering."
      def search_time_entries(workspace_id, params = {})
        params_object = build_params(params)
        params_object.validate_required!
        resource_path = format(request_path, workspace_id: workspace_id)
        response = send_request(request_method, resource_path, params_object)
        response.body_json
      end

      private

      def send_request(request_method, resource_path, body)
        params = body.to_json unless body.is_a?(String)
        TogglRb::Response.new(connection.send(request_method, resource_path, params))
      end

      def connection
        TogglRb::Reports.connection
      end
    end
  end
end

