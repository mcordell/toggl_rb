# frozen_string_literal: true

require "json"

module TogglRb
  module Reports
    class Detailed < Base
      # @param [String|Integer] workspace_id the toggl workspace id we are searching
      # @param [Hash] params the options for searching for time entries
      # @option params [Boolean]        :grouped              Whether time entries should be grouped, optional, default
      #                                                       false.
      # @option params [Boolean]        :hide_amounts         Whether amounts should be hidden, optional, default false.
      # @option params [Integer]        :max_duration_seconds Max duration seconds, optional, filtering attribute.
      #                                                       Time Audit only, should be greater than MinDurationSeconds
      # @option params [Integer]        :min_duration_seconds Min duration seconds, optional, filtering attribute.
      #                                                       Time Audit only, should be less than MaxDurationSeconds.
      # @option params [String]         :order_by             Order by field, optional, default "date". Can
      #                                                       be "date", "user", "duration", "description" or
      #                                                       "last_update".
      # @option params [String]         :order_dir            Order direction, optional. Can be ASC or DESC.
      # @option params [Integer]        :page_size            PageSize defines the number of items per page, optional,
      #                                                       default 50.
      # @option params [Array<String>]  :postedFields         -
      # @option params [Array<Integer>] :project_ids          Project IDs, optional, filtering attribute. To filter
      #                                                       records with no projects, use [null].
      # @option params [Integer]        :rounding             Whether time should be rounded, optional, default from
      #                                                       workspace settings.
      # @option params [Integer]        :rounding_minutes     Rounding minutes value, optional, default from workspace
      #                                                       settings. Should be 0, 1, 5, 6, 10, 12, 15, 30, 60 or 240.
      # @option params [String]         :start_time            -
      # @option params [Array<Integer>] :tag_ids              Tag IDs, optional, filtering attribute. To filter records
      #                                                       with no tags, use [null].
      # @option params [Array<Integer>] :task_ids             Task IDs, optional, filtering attribute. To filter records
      #                                                       with no tasks, use [null].
      # @option params [Array<Integer>] :time_entry_ids       TimeEntryIDs filters by time entries. This was added to
      #                                                       support retro-compatibility with reports v2.
      # @option params [Array<Integer>] :user_ids             User IDs, optional, filtering attribute.
      request_path "workspace/%<workspace_id>s/search/time_entries"
      request_method :post
      param :start_date, Date, :required, description: "should be less than end_date"
      param :end_date, Date, description: "should be greater than start_date"
      param :description, String, description: "filter by description"
      param :billable, "Boolean", description: "Whether the time entry is set to visible (premium feature)"
      param :client_ids, "IntegerArray",
            description: "filter by client ids. Use [nil] to filter records with no clients"
      param :group_ids, "IntegerArray", description: "filter by group ids"
      def search_time_entries(workspace_id, params = {})
        request_options = params.delete(:request_options) || {}
        params_object = build_params(params)
        params_object.validate_required!
        resource_path = format(request_path, workspace_id: workspace_id)
        send_request(request_method, resource_path, params_object, request_options)
      end
    end
  end
end
