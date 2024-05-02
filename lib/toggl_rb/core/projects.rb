# frozen_string_literal: true

module TogglRb
  module Core
    # Projects is the API for the project endpoints
    # @see https://engineering.toggl.com/docs/api/projects#get-workspaceprojects
    class Projects < Base
      request_method :get
      request_path "workspaces/%<workspace_id>s/projects"
      query_param :active,	"boolean", description: "active"
      query_param :since,	Integer,
                  description: "Retrieve projects created/modified/deleted since this date using UNIX timestamp."
      query_param :billable,	"boolean", description: "billable"
      query_param :user_ids,	"array", description: "user_ids"
      query_param :client_ids,	"array", description: "client_ids"
      query_param :group_ids,	"array", description: "group_ids"
      query_param :statuses,	"array", description: "statuses"
      query_param :name,	String, description: "name"
      query_param :page,	Integer, description: "page"
      query_param :sort_field,	String, description: "sort_field"
      query_param :sort_order,	String, description: "sort_order"
      query_param :only_templates,	"boolean", description: "only_templates"
      query_param :per_page,	Integer, description: "Number of items per page, default 151. Cannot exceed 200."
      def search(workspace_id, query_params = {})
        resource_path = build_query_params(query_params).build_url(format(request_path, workspace_id: workspace_id))
        handle_response(send_request(request_method, resource_path))
      end

      request_method :get
      request_path "workspaces/%<workspace_id>s/projects/%<project_id>s"
      def get(workspace_id, project_id)
        resource_path = format(request_path, workspace_id: workspace_id, project_id: project_id)
        handle_response(send_request(request_method, resource_path))
      end

      request_method :post
      request_path "workspaces/%<workspace_id>s/projects"
      param :active, "Boolean", description: "Whether the project is active or archived."
      param :auto_estimates, "Boolean", optional: true, description: "Whether estimates are based on task hours."
      param :billable, "Boolean", optional: true, description: "Whether the project is billable."
      param :cid, Integer, description: "Client ID (legacy)."
      param :client_id, Integer, optional: true, description: "Client ID."
      param :client_name, String, optional: true, description: "Client name."
      param :color, String, description: "Project color."
      param :currency, String, optional: true, description: "Project currency."
      param :end_date, String, description: "End date of the project timeframe."
      param :estimated_hours, Integer, optional: true, description: "Estimated hours for the project."
      param :fixed_fee, "Number", optional: true, description: "Project fixed fee."
      param :is_private, "Boolean", description: "Whether the project is private."
      param :name, String, description: "Project name."
      param :rate, "Number", optional: true, description: "Hourly rate for the project."
      param :rate_change_mode, String, optional: true,
                                       description: "Rate change mode (start-today, override-current, override-all)."
      param :recurring, "Boolean", optional: true, description: "Whether the project is recurring."
      # nested_param :recurring_parameters do
      #   param :custom_period, Integer, description: "Custom period for recurring setting."
      #   param :period, String, description: "Recurring period, e.g., 'monthly'."
      #   param :project_start_date, String, description: "Start date for the recurring project."
      # end
      param :start_date, String, description: "Start date of the project timeframe."
      param :template, "Boolean", optional: true, description: "Whether the project is a template."
      param :template_id, "Integer", optional: true, description: "Template ID for the project."
      # @param workspace_id [String] workspace id
      def create(workspace_id, params)
        resource_path = format(request_path, workspace_id: workspace_id)

        handle_response(send_request(request_method, resource_path, params))
      end

      request_method :patch
      request_path "workspaces/%<workspace_id>s/projects/%<project_ids>s"
      # @param workspace_id [String, Integer] the workspace ID
      # @param project_ids [Array<Integer>] the IDs of the projects update
      # @param operation    [TogglRb::JSONPatch] the operation to apply to the time entries
      def patch(workspace_id, project_ids, operation)
        resource_path = format(request_path, workspace_id: workspace_id, project_ids: project_ids.join(","))

        handle_response(send_request(request_method, resource_path, operation))
      end

      request_method :put
      request_path "workspaces/%<workspace_id>s/projects/%<project_id>s"

      param :active, "Boolean", description: "Whether the project is active or archived."
      param :auto_estimates, "Boolean", optional: true, description: "Whether estimates are based on task hours."
      param :billable, "Boolean", optional: true, description: "Whether the project is billable."
      param :cid, Integer, description: "Client ID (legacy)."
      param :client_id, Integer, optional: true, description: "Client ID."
      param :client_name, String, optional: true, description: "Client name."
      param :color, String, description: "Project color."
      param :currency, String, optional: true, description: "Project currency."
      param :end_date, String, description: "End date of the project timeframe."
      param :estimated_hours, Integer, optional: true, description: "Estimated hours for the project."
      param :fixed_fee, "Number", optional: true, description: "Project fixed fee."
      param :is_private, "Boolean", description: "Whether the project is private."
      param :name, String, description: "Project name."
      param :rate, "Number", optional: true, description: "Hourly rate for the project."
      param :rate_change_mode, String, optional: true,
                                       description: "Rate change mode (start-today, override-current, override-all)."
      param :recurring, "Boolean", optional: true, description: "Whether the project is recurring."
      # nested_param :recurring_parameters do
      #   param :custom_period, Integer, description: "Custom period for recurring setting."
      #   param :period, String, description: "Recurring period, e.g., 'monthly'."
      #   param :project_start_date, String, description: "Start date for the recurring project."
      # end
      param :start_date, String, description: "Start date of the project timeframe."
      param :template, "Boolean", optional: true, description: "Whether the project is a template."
      param :template_id, "Integer", optional: true, description: "Template ID for the project."
      def update(workspace_id, project_id, request_params = {})
        params = build_params(request_params)
        resource_path = format(request_path, workspace_id: workspace_id, project_id: project_id)
        handle_response(send_request(request_method, resource_path, params))
      end

      request_method :delete
      request_path "workspaces/%<workspace_id>s/projects/%<project_id>s"

      # @param workspace_id [String, Integer] the workspace ID
      # @param project_id [Integer] the ID of the project to delete
      # @return [Boolean] whether the delete succeeded
      def delete(workspace_id, project_id)
        resource_path = format(request_path, workspace_id: workspace_id, project_id: project_id)
        response = send_request(request_method, resource_path)
        response.success?
      end

      private

      def handle_response(response)
        return response.body_json if response.success?

        handle_error(response)
      end

      def handle_error(response)
        response.body_json
      end
    end
  end
end
