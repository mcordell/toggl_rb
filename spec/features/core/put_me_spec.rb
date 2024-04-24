# frozen_string_literal: true

RSpec.describe "Core - V9 - Get me endpoint" do
  before do
    TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", nil)
  end

  let(:api) { TogglRb::Core::Me.new }

  let(:user_attributes) do
    {
      beginning_of_week: 0, # Sunday
      country_id: 40, # Canada
      fullname: "Updated withPATCH",
      timezone: "Europe/London"
    }
  end

  describe "PUT /me" do
    context "when updating user settings" do
      # rubocop:disable RSpec/ExampleLength
      it "successfully updates the user settings" do
        VCR.use_cassette("update_user_settings_success") do
          response = api.update(user_attributes)

          expect(response).to match(
            "api_token" => be_a(String),
            "at" => "2024-04-23T15:55:00.906289Z",
            "beginning_of_week" => 0,
            "country_id" => 40,
            "created_at" => "2024-04-09T03:12:46.676852Z",
            "default_workspace_id" => be_a(Integer),
            "email" => be_a(String),
            "fullname" => "Updated withPATCH",
            "has_password" => true,
            "id" => 10_658_406,
            "image_url" => "https://assets.track.toggl.com/images/profile.png",
            "openid_email" => nil,
            "openid_enabled" => false,
            "timezone" => "Europe/London",
            "toggl_accounts_id" => be_a(String),
            "toggl_accounts_updated_at" => "2024-04-23T15:55:01.004574Z",
            "updated_at" => "2024-04-23T15:54:40.151498Z"
          )
        end
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end
end
