# frozen_string_literal: true

RSpec.describe "Core - V9 - Update project", type: :feature do
  let(:api) {  TogglRb::Core::Projects.new }

  let(:new_color) { "#d94182" }
  let(:new_name) { "Updated via PUT" }
  let(:project_id) { 201_876_878 }

  describe "PUT api/v9/workspaces/{workspace_id}/time_entries/{project_id}" do
    context "when updating a project with id and workspace id" do
      it "successfully updates the project" do
        VCR.use_cassette("update_project_success") do
          response = api.update(workspace_id, project_id, { color: new_color, name: new_name })

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
              "color" => new_color,
              "created_at" => "2024-04-09T04:23:27+00:00",
              "currency" => nil,
              "estimated_hours" => nil,
              "estimated_seconds" => nil,
              "fixed_fee" => nil,
              "id" => project_id,
              "is_private" => true,
              "name" => new_name,
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

    context "when an invalid option is specified" do
      let(:new_color) { "#FFFFFF" }

      it "returns an error message" do
        VCR.use_cassette("update_project_bad_attribute") do
          response = api.update(workspace_id, project_id, { color: new_color })

          expect(response).to match(
            "Custom project colors available only for premium plans"
          )
        end
      end
    end
  end
end
