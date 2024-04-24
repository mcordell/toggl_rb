# frozen_string_literal: true

RSpec.describe "Core - V9 - Get time entries for 'me'", type: :feature do
  describe "GET api/v9/me/time_entries" do
    let(:api) { TogglRb::Core::TimeEntries.new }

    it "gets the latest time entries for the user" do
      VCR.use_cassette("get_latest_time_entries_success") do
        response = api.list

        expect(response).to match(
          [{ "at" => "2024-04-12T15:26:15+00:00",
             "billable" => false,
             "description" => "CREATE time entry",
             "duration" => 3600,
             "duronly" => true,
             "id" => 3_404_802_040,
             "permissions" => nil,
             "pid" => 201_876_878,
             "project_id" => 201_876_878,
             "server_deleted_at" => nil,
             "start" => "2024-04-10T08:00:00+00:00",
             "stop" => "2024-04-10T09:00:00+00:00",
             "tag_ids" => [16_009_455, 16_009_456],
             "tags" => %w[development ruby],
             "task_id" => nil,
             "uid" => 10_658_406,
             "user_id" => 10_658_406,
             "wid" => be_a(Integer),
             "workspace_id" => be_a(Integer) },
           { "at" => "2024-04-10T04:30:03+00:00",
             "billable" => false,
             "description" => "The First task",
             "duration" => 6,
             "duronly" => true,
             "id" => 3_398_445_220,
             "permissions" => nil,
             "pid" => 201_899_518,
             "project_id" => 201_899_518,
             "server_deleted_at" => nil,
             "start" => "2024-04-09T04:26:32+00:00",
             "stop" => "2024-04-09T04:26:38+00:00",
             "tag_ids" => [15_986_619, 15_986_620],
             "tags" => %w[tag_1 tag_3],
             "task_id" => nil,
             "uid" => 10_658_406,
             "user_id" => 10_658_406,
             "wid" => be_a(Integer),
             "workspace_id" => be_a(Integer) },
           { "at" => "2024-04-10T04:30:03+00:00",
             "billable" => false,
             "description" => "The First task",
             "duration" => 196,
             "duronly" => true,
             "id" => 3_398_443_148,
             "permissions" => nil,
             "pid" => 201_899_518,
             "project_id" => 201_899_518,
             "server_deleted_at" => nil,
             "start" => "2024-04-09T04:19:52+00:00",
             "stop" => "2024-04-09T04:23:08+00:00",
             "tag_ids" => [15_986_619, 15_986_620],
             "tags" => %w[tag_1 tag_3],
             "task_id" => nil,
             "uid" => 10_658_406,
             "user_id" => 10_658_406,
             "wid" => be_a(Integer),
             "workspace_id" => be_a(Integer) }]
        )
      end
    end

    context "with query parameters" do
      it "gets the latest time entries for the user" do
        VCR.use_cassette("get_latest_time_entries_qp_success") do
          response = api.list(start_date: "2024-04-10", end_date: "2024-04-13")

          puts response
          expect(response).to match(
            [{ "at" => "2024-04-12T15:26:15+00:00",
               "billable" => false,
               "description" => "CREATE time entry",
               "duration" => 3600,
               "duronly" => true,
               "id" => 3_404_802_040,
               "permissions" => nil,
               "pid" => 201_876_878,
               "project_id" => 201_876_878,
               "server_deleted_at" => nil,
               "start" => "2024-04-10T08:00:00+00:00",
               "stop" => "2024-04-10T09:00:00+00:00",
               "tag_ids" => [16_009_455, 16_009_456],
               "tags" => %w[development ruby],
               "task_id" => nil,
               "uid" => 10_658_406,
               "user_id" => 10_658_406,
               "wid" => be_a(Integer),
               "workspace_id" => be_a(Integer) }]
          )
        end
      end
    end
  end
end
