# frozen_string_literal: true

RSpec.describe "Core - V9 - Get a single workspace" do
  before { TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil) }

  let(:workspace_id) { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }

  describe "GET api/v9/workspaces/{workspace_id}" do
    let(:client) { TogglRb::Core::Workspaces.new }

    context "when passed workspace id" do
      it "returns the attributes for the workspace" do
        VCR.use_cassette("get_workspace_success") do
          response = client.get(workspace_id)

          expect(response).to match({
                                      "admin" => true,
                                      "api_token" => be_a(String),
                                      "at" => be_a(String),
                                      "business_ws" => false,
                                      "csv_upload" => nil,
                                      "default_currency" => "USD",
                                      "default_hourly_rate" => nil,
                                      "hide_start_end_times" => false,
                                      "ical_enabled" => true,
                                      "ical_url" => be_a(String),
                                      "id" => be_a(Integer),
                                      "last_modified" => nil,
                                      "logo_url" => "https://assets.track.toggl.com/images/workspace.jpg",
                                      "name" => "toggltest's workspace",
                                      "only_admins_may_create_projects" => false,
                                      "only_admins_may_create_tags" => false,
                                      "only_admins_see_billable_rates" => false,
                                      "only_admins_see_team_dashboard" => false,
                                      "organization_id" => be_a(Integer),
                                      "permissions" => nil,
                                      "premium" => false,
                                      "profile" => 0,
                                      "projects_billable_by_default" => true,
                                      "projects_private_by_default" => true,
                                      "rate_last_updated" => nil,
                                      "reports_collapse" => true,
                                      "role" => "admin",
                                      "rounding" => 1,
                                      "rounding_minutes" => 0,
                                      "server_deleted_at" => nil,
                                      "subscription" => nil,
                                      "suspended_at" => nil,
                                      "working_hours_in_minutes" => nil
                                    })
        end
      end
    end
  end
end
