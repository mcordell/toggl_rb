# frozen_string_literal: true

RSpec.describe "Core - V9 - Bulk edit multiple time entries" do
  before do
    TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil)
    @client = TogglRb::Core::TimeEntries.new
  end

  let(:workspace_id) { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }
  let(:other_project_id) { 201_899_518 }
  let(:operation) { TogglRb.operation.replace("/pid", other_project_id) }
  let(:time_entries) { [3_398_443_148, 3_398_445_220] }

  describe "PATCH api/v9/workspaces/{workspace_id}/time_entries/{time_entry_ids}" do
    context "when passed a workspace id, an array of time entries and an operation" do
      it "runs the operation successfully" do
        VCR.use_cassette("bulk_patch_time_entries_success") do
          response = @client.patch(workspace_id, time_entries, operation)

          expect(response).to match({ "success" => be_a(Array), "failure" => be_a(Array) })

          expect(response["success"].count).to eq 2
        end
      end
    end
  end
end
