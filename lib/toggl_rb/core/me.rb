# frozen_string_literal: true

require "json"

module TogglRb
  module Core
    class Me < Base
      request_method :get
      request_path "me"
      query_param :with_related_data, "Boolean", description: "whether to include related data"
      # @param with_related_data [Boolean] whether to include related data
      def get(with_related_data: false)
        resource_path = with_related_data ? "#{request_path}?with_related_data=true" : request_path
        send_request(request_method, resource_path)
      end

      request_method :put
      request_path "me"

      param :beginning_of_week, Integer, description: "User's first day of the week. Sunday: 0, Monday: 1, etc."
      param :country_id, Integer, description: "User's country ID"
      param :current_password, String, description: "User's current password (used to change the current password)"
      param :default_workspace_id, Integer, description: "User's default workspace ID"
      param :email, String, description: "User's email address"
      param :fullname, String, description: "User's full name"
      param :password, String, description: "User's new password (current one must also be provided)"
      param :timezone, String, description: "User's timezone"
      def update(params)
        send_request(request_method, request_path, build_params(params))
      end

      request_method :get
      request_path "me/workspaces"
      query_param :since, Date,
                  description: "Retrieve workspaces created/modified/deleted since this date using UNIX timestamp, " \
                               "including the dates a workspace member got added, removed or updated in the workspace."
      def workspaces(query_params = {})
        # TODO: implement since query_param
        query_params["since"]
        send_request(request_method, request_path)
      end
    end
  end
end
