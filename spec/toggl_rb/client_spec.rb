# frozen_string_literal: true

module TogglRb
  RSpec.describe Client do
    let(:username) { nil }
    let(:password) { nil }
    let(:api_token) { nil }
    let(:basic_auth) { false }
    let(:config_double) do
      instance_double(TogglRb::Config,
                      username: username,
                      password: password,
                      api_token: api_token,
                      basic_auth?: basic_auth,
                      api_token?: !!api_token)
    end

    before do
      allow(TogglRb).to receive(:config).and_return(config_double)
    end

    describe "initialization" do
      context "when no authentication is not configured" do
        it "initializes base_connection and reports_connection without authentication" do
          client = Client.new

          expect(client.base_connection.headers).not_to include("Authorization")
          expect(client.reports_connection.headers).to include("Content-Type" => "application/json",
                                                               "Accept" => "application/json")
          expect(client.reports_connection.headers).not_to include("Authorization")
        end
      end

      context "when using basic auth" do
        let(:basic_auth) { true }
        let(:username) { "user" }
        let(:password) { "pass" }

        it "initializes reports_connection with basic auth" do
          client = Client.new

          expect(client.reports_connection.headers).to include("Content-Type" => "application/json",
                                                               "Accept" => "application/json",
                                                               "Authorization" => "Basic " +
            Base64.encode64("#{username}:#{password}").chomp)
        end
      end

      context "when using an API token" do
        let(:api_token) { "RANDOM_STRING" }

        it "initializes reports_connection with API token as basic auth" do
          client = Client.new

          expect(client.reports_connection.headers).to include("Content-Type" => "application/json",
                                                               "Accept" => "application/json",
                                                               "Authorization" => "Basic " +
            Base64.encode64("#{api_token}:api_token").chomp)
        end
      end
    end
  end
end
