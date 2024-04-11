# frozen_string_literal: true

module TogglRb
  module Core
    class Projects
      include TogglRb::EndpointDSL

      request_method :get
      request_path "workspaces/%<workspace_id>s/projects"
      query_param :active, "Boolean"
      query_param :since, "Boolean"
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
        params = build_query_params(query_params)
        resource_path = format(request_path, workspace_id: workspace_id)
        response = connection.get(resource_path) do |request|
          request.params = params.request_params
        end
        Response.new(response)
      end

      private

      def connection
        TogglRb::Core.connection
      end
    end
  end
end
