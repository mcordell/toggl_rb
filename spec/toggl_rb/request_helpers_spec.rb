# frozen_string_literal: true

module TogglRb
  RSpec.describe RequestHelpers do
    let(:dummy_class) do
      Class.new do
        include TogglRb::RequestHelpers
      end
    end
    let(:connection) { instance_double(TogglRb::Connection) }
    let(:request) { instance_double(Faraday::Request) }
    let(:response) { instance_double(Faraday::Response, body: '{"success": true}', status: 200) }
    let(:api) { dummy_class.new }

    context "when the API endpoint does not implement #connection" do
      context "when sending a request" do
        it "raises and error" do
          expect do
            api.send_request(:get, "/test")
          end.to raise_error(RuntimeError, "Connection is not implemented")
        end
      end
    end

    context "when the API endpoint implements #connection" do
      before do
        allow(api).to receive(:connection).and_return(connection)
      end

      context "when sending a GET request" do
        it "delegates to Connection and returns a TogglRb::Response" do
          allow(connection).to receive(:get).with("/test").and_return(response)
          result = api.send_request(:get, "/test")
          expect(result).to be_an_instance_of(TogglRb::Response)
        end
      end

      context "when sending a POST request with JSON body" do
        it "sends a request with a JSON body" do
          json_body = { data: "value" }.to_json
          allow(connection).to receive(:send).with(:post, "/test", json_body).and_return(response)
          result = api.send_request(:post, "/test", { data: "value" })
          expect(result).to be_an_instance_of(TogglRb::Response)
        end
      end
    end
  end
end
