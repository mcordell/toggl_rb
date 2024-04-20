# frozen_string_literal: true

RSpec.describe "Core - V9 - Create a project" do
  before do
    TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil)
    @client = TogglRb::Core::Projects.new
  end

  let(:workspace_id) { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }
  let(:description) { "Created project via API" }
  let(:project_attributes) do
    {
      name: description
    }
  end

  describe "POST api/v9/workspaces/{workspace_id}/projects" do
    context "when creating a new project" do
      it "successfully creates a project" do
        VCR.use_cassette("create_project_success") do
          response = @client.create(workspace_id, project_attributes)

          expect(response).to match(
            { "id" => 201_991_297,
              "workspace_id" => be_a(Integer),
              "client_id" => nil,
              "name" => description,
              "is_private" => true,
              "active" => false,
              "at" => "2024-04-14T17:54:22+00:00",
              "server_deleted_at" => nil,
              "color" => "#0b83d9",
              "billable" => nil,
              "template" => nil,
              "auto_estimates" => nil,
              "estimated_hours" => nil,
              "estimated_seconds" => nil,
              "rate" => nil,
              "rate_last_updated" => nil,
              "currency" => nil,
              "recurring" => false,
              "template_id" => nil,
              "recurring_parameters" => nil,
              "fixed_fee" => nil,
              "actual_hours" => nil,
              "actual_seconds" => nil,
              "start_date" => "2024-04-14",
              "wid" => be_a(Integer),
              "cid" => nil,
              "permissions" => nil }
          )
        end
      end
    end
  end
end
