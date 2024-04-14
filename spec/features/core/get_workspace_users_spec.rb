# frozen_string_literal: true

RSpec.describe "Core - V9 - Get Users in Workspace endpoint", type: :feature do
  before { TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil) }

  let(:workspace_id) { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }
  let(:organization_id) { ENV.fetch("TOGGL_ORGANIZATION_ID", nil) }

  describe "GET api/v9/workspaces/{workspace_id}/groups" do
    let(:client) { TogglRb::Core::Users.new }
    context "when passed an organization id and workspace id" do
      it "runs the operation successfully" do
        VCR.use_cassette("get_workspace_users_success") do
          response = client.list(workspace_id)

          expect(response).to match(
            [{ "email" => be_a(String),
               "fullname" => "Michael C",
               "id" => 10_658_406,
               "inactive" => false,
               "is_active" => true,
               "is_admin" => true }]
          )
        end
      end
    end
  end

  describe "GET api/v9/organizations/{organization_id}/workspaces/{workspace_id}/groups" do
    let(:client) { TogglRb::Core::Groups.new }
    context "when passed an organization id and workspace id" do
      it "runs the operation successfully" do
        VCR.use_cassette("get_organization_workspace_users_success") do
          response = client.list(organization_id: organization_id, workspace_id: workspace_id)

          expect(response).to match(
            [{ "at" => "2024-04-13T20:04:48.278682Z",
               "group_id" => 188_929,
               "name" => "Cool Kids",
               "users" =>
                    [{ "avatar_url" => "",
                       "joined" => true,
                       "name" => "Michael C",
                       "user_id" => 10_658_406 }],
               "workspaces" => [be_a(Integer)] }]
          )
        end
      end
    end
  end
end
