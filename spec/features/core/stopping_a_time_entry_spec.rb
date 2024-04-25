# frozen_string_literal: true

RSpec.describe "Core - V9 - Stop a Running Time Entry", type: :feature do
  describe "PATCH api/v9/workspaces/{workspace_id}/time_entries/{time_entry_id}/stop" do
    let(:api) { TogglRb::Core::TimeEntries.new }
    let(:time_entry_id) { 3_421_446_028 }

    context "when the entry is running" do
      it "returns the updated entry" do
        VCR.use_cassette("stop_a_running_entry_success") do
          response = api.stop(workspace_id, time_entry_id)
          expect(response).to match(
            "at" => "2024-04-25T03:28:07+00:00",
            "billable" => false,
            "description" => "Time entry running!!",
            "duration" => 414,
            "duronly" => true,
            "id" => time_entry_id,
            "permissions" => nil,
            "project_id" => nil,
            "server_deleted_at" => nil,
            "start" => "2024-04-25T03:21:13Z",
            "stop" => "2024-04-25T03:28:07Z",
            "tag_ids" => [],
            "tags" => [],
            "task_id" => nil,
            "uid" => 10_658_406,
            "user_id" => 10_658_406,
            "wid" => be_a(Integer),
            "workspace_id" => be_a(Integer)
          )
        end
      end
    end

    context "when the entry has already been stopped" do
      it "returns a message saying the time entry is already stopped" do
        VCR.use_cassette("stop_a_stopped_entry_success") do
          response = api.stop(workspace_id, time_entry_id)
          expect(response).to match(
            "Time entry already stopped"
          )
        end
      end
    end
  end
end
