# frozen_string_literal: true

RSpec.describe "Core - V9 - Get me endpoint" do
  before do
    TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil)
    @client = TogglRb::Core::Me.new
  end

  describe "GET api/v9/me" do
    context "when the related data variable is not toggled" do
      it "runs the operation successfully" do
        VCR.use_cassette("get_me_success_short") do
          response = @client.get

          expect(response).to match(
            {
              "api_token" => be_a(String),
              "at" => "2024-04-10T04:21:12.272198Z",
              "authorization_updated_at" => "2024-04-09T19:05:32.790318Z",
              "beginning_of_week" => 1,
              "country_id" => nil,
              "created_at" => "2024-04-09T03:12:46.676852Z",
              "default_workspace_id" => be_a(Integer),
              "email" => be_a(String),
              "fullname" => "Michael C",
              "has_password" => true,
              "id" => 10_658_406,
              "image_url" => "https://assets.track.toggl.com/images/profile.png",
              "intercom_hash" => "f57a6e453be5ea03dfeb604497de4fc1d216224908a302710c71401c399a6283",
              "openid_email" => nil,
              "openid_enabled" => false,
              "timezone" => "America/Los_Angeles",
              "toggl_accounts_id" => "AXnZJWgbGgyrdT6a9tcR6X",
              "updated_at" => "2024-04-09T20:22:21.519922Z"
            }
          )
        end
      end
    end

    context "when the related data variable is toggled" do
      it "runs the operation successfully" do
        VCR.use_cassette("get_me_success_long") do
          response = @client.get(with_related_data: true)

          expect(response).to match(
            {
              "api_token" => be_a(String),
              "at" => "2024-04-10T04:20:44.729812Z",
              "authorization_updated_at" => "2024-04-09T19:05:32.790318Z",
              "beginning_of_week" => 1,
              "country_id" => nil,
              "created_at" => "2024-04-09T03:12:46.676852Z",
              "default_workspace_id" => be_a(Integer),
              "email" => be_a(String),
              "fullname" => "Michael C",
              "has_password" => true,
              "id" => 10_658_406,
              "image_url" => "https://assets.track.toggl.com/images/profile.png",
              "intercom_hash" => "f57a6e453be5ea03dfeb604497de4fc1d216224908a302710c71401c399a6283",
              "openid_email" => nil,
              "openid_enabled" => false,
              "projects" => be_a(Array),
              "tags" => be_a(Array),
              "time_entries" => be_a(Array),
              "timezone" => "America/Los_Angeles",
              "toggl_accounts_id" => "AXnZJWgbGgyrdT6a9tcR6X",
              "updated_at" => "2024-04-09T20:22:21.519922Z",
              "workspaces" => be_a(Array)
            }
          )
        end
      end
    end
  end
end
