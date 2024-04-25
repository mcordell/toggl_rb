# frozen_string_literal: true

RSpec.describe "Core - V9 - Get the current time entry for the user", type: :feature do
  describe "GET api/v9/me/time_entries/current" do
    let(:api) { TogglRb::Core::TimeEntries.new }

    context "when there is not a running time entry" do
      it "returns nil" do
        VCR.use_cassette("get_current_time_entry_success") do
          response = api.current
          expect(response).to be_nil
        end
      end
    end

    it "gets the latest time entry for the user" do
      VCR.use_cassette("get_current_time_entry_is_running") do
        response = api.current
        expect(response).to match(
          "at" => "2024-04-25T03:21:13+00:00",
          "billable" => false,
          "description" => "Time entry running!!",
          "duration" => -1_714_015_273,
          "duronly" => true,
          "id" => 3_421_446_028,
          "permissions" => nil,
          "project_id" => nil,
          "server_deleted_at" => nil,
          "start" => "2024-04-25T03:21:13+00:00",
          "stop" => nil,
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
end
