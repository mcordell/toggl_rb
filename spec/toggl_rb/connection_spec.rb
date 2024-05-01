# frozen_string_literal: true

module TogglRb
  RSpec.describe Connection do
    let(:url) { "https://www.google.com" }

    subject(:instance) { described_class.new(url) }

    it { is_expected.to respond_to(:put) }
    it { is_expected.to respond_to(:post) }
    it { is_expected.to respond_to(:get) }
    it { is_expected.to respond_to(:patch) }
    it { is_expected.to respond_to(:headers) }

    describe "#api_token=" do
      let(:api_token) { "test1234" }

      before { instance.api_token = api_token }

      it "sets the instance variable" do
        expect(instance.instance_variable_get(:@api_token)).to eq api_token
      end

      it "uses that token in requests" do
        faraday_connection = instance.send(:faraday_connection)

        api_token_auth_header = "Basic #{Base64.encode64("#{api_token}:api_token").chomp}"
        expect(faraday_connection.headers[:authorization]).to eq(api_token_auth_header)
      end
    end
  end
end
