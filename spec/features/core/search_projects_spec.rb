# frozen_string_literal: true

RSpec.describe "Core - V9 - Search For Project", type: :feature do
  before do
    TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil)
    @client = TogglRb::Core::Projects.new
  end
  let(:workspace_id) { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }

  describe "GET api/v9/workspaces/{workspace_id}/projects" do
    it "runs the operation successfully" do
      VCR.use_cassette("search_projects_no_filter") do
        response = @client.search(workspace_id)

        expect(response.body_json).to match(
          [{ "active" => true,
             "actual_hours" => 0,
             "actual_seconds" => 202,
             "at" => "2024-04-09T19:05:31+00:00",
             "auto_estimates" => nil,
             "billable" => nil,
             "cid" => nil,
             "client_id" => nil,
             "color" => "#bf7000",
             "created_at" => "2024-04-09T19:05:31+00:00",
             "currency" => nil,
             "estimated_hours" => nil,
             "estimated_seconds" => nil,
             "fixed_fee" => nil,
             "id" => 201_899_518,
             "is_private" => true,
             "name" => "A Different Project",
             "permissions" => nil,
             "rate" => nil,
             "rate_last_updated" => nil,
             "recurring" => false,
             "recurring_parameters" => nil,
             "server_deleted_at" => nil,
             "start_date" => "2024-04-09",
             "status" => "active",
             "template" => nil,
             "template_id" => nil,
             "wid" => be_a(Integer),
             "workspace_id" => be_a(Integer) },
           { "active" => true,
             "actual_hours" => 0,
             "actual_seconds" => 0,
             "at" => "2024-04-09T04:23:27+00:00",
             "auto_estimates" => nil,
             "billable" => nil,
             "cid" => nil,
             "client_id" => nil,
             "color" => "#c9806b",
             "created_at" => "2024-04-09T04:23:27+00:00",
             "currency" => nil,
             "estimated_hours" => nil,
             "estimated_seconds" => nil,
             "fixed_fee" => nil,
             "id" => 201_876_878,
             "is_private" => true,
             "name" => "A project",
             "permissions" => nil,
             "rate" => nil,
             "rate_last_updated" => nil,
             "recurring" => false,
             "recurring_parameters" => nil,
             "server_deleted_at" => nil,
             "start_date" => "2024-04-09",
             "status" => "active",
             "template" => nil,
             "template_id" => nil,
             "wid" => be_a(Integer),
             "workspace_id" => be_a(Integer) }]
        )
      end
    end

    context "searching by name param" do
      it "runs the operation successfully" do
        VCR.use_cassette("search_project_by_name") do
          response = @client.search(workspace_id, name: "A project")
          expect(response.body_json.count).to eq 1

          expect(response.body_json[0]["name"]).to eq "A project"
        end
      end
    end
  end
end
