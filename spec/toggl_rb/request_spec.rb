# frozen_string_literal: true

module TogglRb
  RSpec.describe Request do
    let(:connection) { instance_double(TogglRb::Connection) }
    let(:request) { instance_double(Faraday::Request) }
    let(:response) { instance_double(Faraday::Response, body: '{"success": true}', status: 200) }
    let(:request_instance) { described_class.new(connection) }

    describe ".send_request" do
      subject(:returned_val) { described_class.send_request(connection, :get, "/test") }

      it "creates a new request instance and sends it" do
        resp = TogglRb::Response.new(response)
        allow(described_class).to receive(:new).with(connection).and_return(request_instance)
        allow(request_instance).to receive(:send_request).with(:get, "/test",
                                                               nil).and_return(resp)
        expect(returned_val).to eq resp
      end
    end

    describe "#send_request" do
      context "when body is an invalid type" do
        it "raises an Argument Error" do
          expect do
            request_instance.send_request(:post, "/test", 12)
          end.to raise_error(ArgumentError, "Unknown body type 12")
        end
      end

      context "when logging is enabled" do
        let(:logger_output) { StringIO.new }

        around do |ex|
          old_val = TogglRb.config.debug_logging
          old_logger = TogglRb.config.logger
          TogglRb.config.debug_logging = true
          TogglRb.config.logger = Logger.new(logger_output)
          ex.run
          TogglRb.config.debug_logging = old_val
          TogglRb.config.logger = old_logger
        end

        it "logs the request" do
          allow(connection).to receive(:send).with(:get, "/test").and_return(response)
          request_instance.send_request(:get, "/test")
          expect(logger_output.string).to match(%r{.*INFO.*GET /test\n})
        end
      end

      context "when no body is provided" do
        it "sends a GET request without a body" do
          allow(connection).to receive(:send).with(:get, "/test").and_return(response)
          result = request_instance.send_request(:get, "/test")
          expect(result).to be_an_instance_of(TogglRb::Response)
        end
      end

      context "when body is provided" do
        it "sends a POST request with JSON body" do
          json_body = { data: "value" }.to_json
          allow(connection).to receive(:send).with(:post, "/test", json_body).and_return(response)
          result = request_instance.send_request(:post, "/test", { data: "value" })
          expect(result).to be_an_instance_of(TogglRb::Response)
        end
      end
    end
  end
end
