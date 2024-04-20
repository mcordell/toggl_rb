# frozen_string_literal: true

RSpec.describe "Core - V9 - Get workspaces for me endpoint" do
  before do
    TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil)
    @client = TogglRb::Core::Me.new
  end

  describe "GET api/v9/me/workspaces" do
    context "when the related data variable is not toggled" do
      it "runs the operation successfully" do
        VCR.use_cassette("get_me_workspaces_success") do
          response = @client.workspaces

          expect(response).to match(
            [{ "admin" => true,
               "api_token" => "2f3d23fcb96702e1e4a9058f349dd6f3",
               "at" => "2024-04-14T17:01:34+00:00",
               "business_ws" => false,
               "csv_upload" => nil,
               "default_currency" => "USD",
               "default_hourly_rate" => nil,
               "hide_start_end_times" => false,
               "ical_enabled" => true,
               "ical_url" => be_a(String),
               "id" => be_a(Integer),
               "last_modified" => "2024-04-14T00:00:00Z",
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
               "working_hours_in_minutes" => nil }]
          )
        end
      end
    end
  end
end
