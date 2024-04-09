# frozen_string_literal: true

require "json"

module TogglRb
  module Reports
    class Detailed
      # @param [Hash] params the options for searching for time entries for
      # @option params [String]         :description          Description, optional, filtering attribute.
      # @option params [Array<Integer>] :client_ids           Client IDs, optional, filtering attribute. To filter records
      #                                                       with no clients, use [nil].
      # @option params [Boolean]        :billable             Whether the time entry is set as billable, optional, premium
      #                                                       feature.
      # @option params [String]         :end_date             End date, example time.DateOnly. Should be greater than
      #                                                       Start date.
      # @option params [Array<Integer>] :group_ids            Group IDs, optional, filtering attribute.
      # @option params [Boolean]        :grouped              Whether time entries should be grouped, optional, default
      #                                                       false.
      # @option params [Boolean]        :hide_amounts         Whether amounts should be hidden, optional, default false.
      # @option params [Integer]        :max_duration_seconds Max duration seconds, optional, filtering attribute.
      #                                                       Time Audit only, should be greater than MinDurationSeconds.
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
      # @option params [String]         :startTime            -
      # @option params [String]         :start_date           Start date, example time.DateOnly. Should be less than End
      #                                                       date.
      # @option params [Array<Integer>] :tag_ids              Tag IDs, optional, filtering attribute. To filter records
      #                                                       with no tags, use [null].
      # @option params [Array<Integer>] :task_ids             Task IDs, optional, filtering attribute. To filter records
      #                                                       with no tasks, use [null].
      # @option params [Array<Integer>] :time_entry_ids       TimeEntryIDs filters by time entries. This was added to
      #                                                       support retro-compatibility with reports v2.
      # @option params [Array<Integer>] :user_ids             User IDs, optional, filtering attribute.
      def search_time_entries(params = {})
        workspace_id = params.delete(:workspace_id)
        raise ArgumentError, ":workspace_id param must be provided" if workspace_id.nil?
        raise ArgumentError, ":start_date param must be provided" unless params.key? :start_date

        resource_path = "workspace/#{workspace_id}/search/time_entries"
        resp = connection.post resource_path, params.to_json

        return {} if resp == {}

        JSON.parse(resp.body)
      end

      private

      def connection
        TogglRb::Reports.connection
      end
    end
  end
end
