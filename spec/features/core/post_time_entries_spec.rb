# frozen_string_literal: true

RSpec.describe "Core - V9 - Create time entry", type: :feature do
  let(:api) {  TogglRb::Core::TimeEntries.new }

  let(:description) { "CREATE time entry" }
  let(:start_time) do
    DateTime.new(2024, 4, 10, 8, 0, 0)
  end
  let(:project_id) { 201_876_878 }
  let(:time_entry_attributes) do
    {
      description: description,
      start: start_time,
      duration: 3600, # 1 hour
      pid: project_id,
      tags: %w[development ruby],
      created_with: "TogglRb"
    }
  end

  describe "POST api/v9/workspaces/{workspace_id}/time_entries" do
    context "when creating a new time entry" do
      it "successfully creates a time entry" do
        VCR.use_cassette("create_time_entry_success") do
          response = api.create(workspace_id, time_entry_attributes)

          expect(response).to match(
            "at" => "2024-04-12T15:26:15+00:00",
            "billable" => false,
            "description" => description,
            "duration" => 3600,
            "duronly" => true,
            "id" => 3_404_802_040,
            "permissions" => nil,
            "pid" => 201_876_878,
            "project_id" => project_id,
            "server_deleted_at" => nil,
            "start" => "2024-04-10T08:00:00Z",
            "stop" => "2024-04-10T09:00:00Z",
            "tag_ids" => [16_009_455, 16_009_456],
            "tags" => %w[development ruby],
            "task_id" => nil,
            "uid" => 10_658_406,
            "user_id" => 10_658_406,
            "wid" => be_a(Integer),
            "workspace_id" => be_a(Integer)
          )
        end
      end
    end
  end
end
