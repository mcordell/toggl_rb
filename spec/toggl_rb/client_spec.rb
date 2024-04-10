# frozen_string_literal: true

require "base64"

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
                      api_token?: !api_token.nil?)
    end

    before do
      allow(TogglRb).to receive(:config).and_return(config_double)
    end

    describe "initialization" do
      context "when authentication is not configured" do
        it "initializes core_connection and reports_connection without authentication" do
          client = Client.new

          expect(client.core_connection.headers).not_to include("Authorization")
          expect(client.core_connection.headers).to include("Content-Type" => "application/json",
                                                            "Accept" => "application/json")
          expect(client.reports_connection.headers).not_to include("Authorization")
          expect(client.reports_connection.headers).to include("Content-Type" => "application/json",
                                                               "Accept" => "application/json")
        end
      end

      context "when using basic auth" do
        let(:basic_auth) { true }
        let(:username) { "user" }
        let(:password) { "pass" }

        it "initializes core_connection and reports_connection with basic auth" do
          client = Client.new

          basic_auth_header = "Basic #{Base64.encode64("#{username}:#{password}").chomp}"
          expect(client.core_connection.headers).to include("Authorization" => basic_auth_header)
          expect(client.reports_connection.headers).to include("Authorization" => basic_auth_header)
        end
      end

      context "when using an API token" do
        let(:api_token) { "RANDOM_STRING" }

        it "initializes core_connection and reports_connection with API token as basic auth" do
          client = Client.new

          api_token_auth_header = "Basic #{Base64.encode64("#{api_token}:api_token").chomp}"
          expect(client.core_connection.headers).to include("Authorization" => api_token_auth_header)
          expect(client.reports_connection.headers).to include("Authorization" => api_token_auth_header)
        end
      end
    end
  end
end
