# frozen_string_literal: true

RSpec.describe "Core - V9 - Get a time entry by id", type: :feature do
  describe "GET api/v9/me/time_entries/current/{time_entry_id}" do
    let(:api) { TogglRb::Core::TimeEntries.new }
    let(:time_entry_id) { 3_404_802_040 }

    context "when passed a time_entry_id" do
      it "gets the latest time entry for the user" do
        VCR.use_cassette("get_time_entry_by_id_success") do
          response = api.get(time_entry_id)

          expect(response).to match(
            { "at" => "2024-04-12T15:26:15+00:00",
              "billable" => false,
              "description" => "CREATE time entry",
              "duration" => 3600,
              "duronly" => true,
              "id" => 3_404_802_040,
              "permissions" => nil,
              "project_id" => 201_876_878,
              "server_deleted_at" => nil,
              "start" => "2024-04-10T08:00:00+00:00",
              "stop" => "2024-04-10T09:00:00+00:00",
              "tag_ids" => [16_009_455, 16_009_456],
              "tags" => %w[development ruby],
              "task_id" => nil,
              "user_id" => 10_658_406,
              "workspace_id" => be_a(Integer) }
          )
        end
      end
    end

    context "with query parameters" do
      it "gets the time entry with the query parameter option" do
        VCR.use_cassette("get_time_entry_by_id_qp_success") do
          response = api.get(time_entry_id, meta: true, include_sharing: true)

          expect(response).to match(
            "at" => "2024-04-12T15:26:15+00:00",
            "billable" => false,
            "description" => "CREATE time entry",
            "duration" => 3600,
            "duronly" => true,
            "id" => 3_404_802_040,
            "permissions" => nil,
            "project_active" => true,
            "project_color" => "#c9806b",
            "project_id" => 201_876_878,
            "project_name" => "A project",
            "server_deleted_at" => nil,
            "start" => "2024-04-10T08:00:00+00:00",
            "stop" => "2024-04-10T09:00:00+00:00",
            "tag_ids" => [16_009_455, 16_009_456],
            "tags" => %w[development ruby],
            "task_id" => nil,
            "user_id" => 10_658_406,
            "workspace_id" => be_a(Integer)
          )
        end
      end
    end
  end
end
