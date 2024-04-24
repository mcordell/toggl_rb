# frozen_string_literal: true

RSpec.describe "Reporting - V3 - Detailed Reporting", type: :feature do
  let(:api) { TogglRb::Reports::Summary.new }

  describe "POST /reports/api/v3/workspace/WID/search/time_entries/" do
    context "when valid parameters are provided" do
      it "returns an array of time entry hashes" do
        VCR.use_cassette("serach_summary_time_entries_success") do
          response = api.search_time_entries(workspace_id,
                                             start_date: "2024-04-01",
                                             end_date: "2024-04-15", grouping: "projects")

          expect(response).to match(
            { "groups" =>
             [{ "id" => 201_876_878,
                "project_color" => "0",
                "project_hex_color" => "#c9806b",
                "sub_groups" =>
                [{ "DistinguishRates" => false,
                   "ForExport" => false,
                   "Grouping" => "projects",
                   "SubGrouping" => "time_entries",
                   "id" => nil,
                   "local_start" => "2024-04-10T01:00:00Z",
                   "project_color" => "0",
                   "project_hex_color" => "#c9806b",
                   "seconds" => 3600,
                   "title" => "CREATE time entry" }] },
              { "id" => 201_899_518,
                "project_color" => "0",
                "project_hex_color" => "#bf7000",
                "sub_groups" =>
                [{ "DistinguishRates" => false,
                   "ForExport" => false,
                   "Grouping" => "projects",
                   "SubGrouping" => "time_entries",
                   "id" => nil,
                   "local_start" => "2024-04-08T21:19:52Z",
                   "project_color" => "0",
                   "project_hex_color" => "#bf7000",
                   "seconds" => 202,
                   "title" => "The First task" }] }] }
          )
        end
      end
    end
  end
end
