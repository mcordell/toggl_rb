require "spec_helper"

RSpec.describe "Reporting - V3 - Detailed Reporting", type: :feature do
  before do
    TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil)
    @client = TogglRb::Reports::Detailed.new
  end

  let(:workspace_id) { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }

  describe "POST /reports/api/v3/workspace/WID/search/time_entries/" do
    context "when valid parameters are provided" do
      it "returns an array of time entry hashes" do
        VCR.use_cassette("search_time_entries_simple_success") do
          response = @client.search_time_entries(workspace_id, start_date: "2024-04-07")

          expect(response.count).to eq 2
          expect(response).to all include("time_entries", "user_id")
        end
      end
    end

    context "when start_date is not provided" do
      it "throws an ArgumentError" do
        expect do
          @client.search_time_entries(workspace_id, project_ids: [nil])
        end.to raise_error(ArgumentError, ":start_date param must be provided")
      end
    end
  end
end
