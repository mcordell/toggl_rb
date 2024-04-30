# frozen_string_literal: true

RSpec.describe "Core - V9 - Delete time entry", type: :feature do
  let(:api) {  TogglRb::Core::TimeEntries.new }

  let(:time_entry_id) { 3_404_802_040 }

  describe "DELETE api/v9/workspaces/{workspace_id}/time_entries/{time_entry_id}" do
    context "when updating a time entry with id and workspace id" do
      it "successfully delete the time entry" do
        VCR.use_cassette("delete_time_entry_success") do
          response = api.delete(workspace_id, time_entry_id)

          expect(response).to be true
        end
      end
    end
  end
end
