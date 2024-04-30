# frozen_string_literal: true

RSpec.describe "Core - V9 - Update time entry", type: :feature do
  let(:api) {  TogglRb::Core::TimeEntries.new }

  let(:description) { "UPDATE time entry" }
  let(:time_entry_id) { 3_404_802_040 }

  describe "PUT api/v9/workspaces/{workspace_id}/time_entries/{time_entry_id}" do
    context "when updating a time entry with id and workspace id" do
      it "successfully updates the time entry" do
        VCR.use_cassette("update_time_entry_success") do
          response = api.update(workspace_id, time_entry_id, { description: description })

          expect(response).to match(
            "at" => "2024-04-29T15:43:26+00:00",
            "billable" => false,
            "description" => description,
            "duration" => 3600,
            "duronly" => true,
            "id" => time_entry_id,
            "permissions" => nil,
            "pid" => 201_876_878,
            "project_id" => 201_876_878,
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
