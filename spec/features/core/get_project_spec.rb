# frozen_string_literal: true

RSpec.describe "Core - V9 - Get a project by id", type: :feature do
  describe "GET api/v9/workspace/{workspace_id}/projects/{project_id}" do
    let(:api) { TogglRb::Core::Projects.new }
    let(:project_id) { 201_876_878 }

    context "when passed a workspace id and project_id" do
      it "gets the project" do
        VCR.use_cassette("get_project_by_id_success") do
          response = api.get(workspace_id, project_id)

          expect(response).to match(
            {
              "active" => true,
              "actual_hours" => nil,
              "actual_seconds" => nil,
              "at" => "2024-05-02T00:03:40+00:00",
              "auto_estimates" => nil,
              "billable" => nil,
              "cid" => nil,
              "client_id" => nil,
              "color" => "#000000",
              "created_at" => "2024-04-09T04:23:27+00:00",
              "currency" => nil,
              "estimated_hours" => nil,
              "estimated_seconds" => nil,
              "fixed_fee" => nil,
              "id" => project_id,
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
              "workspace_id" => be_a(Integer)
            }
          )
        end
      end
    end
  end
end
