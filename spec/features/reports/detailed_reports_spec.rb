# frozen_string_literal: true

RSpec.describe "Reporting - V3 - Detailed Reporting", type: :feature do
  let(:client) { TogglRb::Reports::Detailed.new }

  describe "POST /reports/api/v3/workspace/WID/search/time_entries/" do
    context "when valid parameters are provided" do
      it "returns an array of time entry hashes" do
        VCR.use_cassette("search_time_entries_simple_success") do
          response = client.search_time_entries(workspace_id, { start_date: "2024-04-07" })

          expect(response.count).to eq 2
          expect(response).to all include("time_entries", "user_id")
        end
      end
    end

    context "when multiple pages exist" do
      it "returns an array of time entry hashes with only the first page" do
        VCR.use_cassette("search_time_entries_long_first_page") do
          response = client.search_time_entries(workspace_id, { start_date: "2023-12-01", end_date: "2023-12-31" })

          expect(response.count).to eq 50
          expect(response).to all include("time_entries", "user_id")
        end
      end

      context "with the get_all request option set" do
        it "returns all pages on time entry hashes" do
          VCR.use_cassette("search_time_entries_long_all_pages") do
            response = client.search_time_entries(workspace_id,
                                                  { start_date: "2023-12-01", end_date: "2023-12-31",
                                                    request_options: { get_all: true } })

            expect(response.count).to eq 100
            expect(response).to all include("time_entries", "user_id")
          end
        end
      end
    end

    context "when start_date is not provided" do
      it "throws an ArgumentError" do
        expect do
          client.search_time_entries(workspace_id, { project_ids: [nil] })
        end.to raise_error(ArgumentError, "start_date param must be provided")
      end
    end
  end
end
