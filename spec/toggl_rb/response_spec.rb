# frozen_string_literal: true

RSpec.describe TogglRb::Response do
  # Mocking a Faraday response object
  let(:faraday_response_double) do
    instance_double("Faraday::Response", body: '{"key":"value"}', status: 200)
  end

  let(:response) { described_class.new(faraday_response_double) }

  describe "#body_json" do
    it "parses the JSON body of the Faraday response" do
      expect(response.body_json).to eq({ "key" => "value" })
    end

    it "memoizes the parsed JSON body" do
      expect(JSON).to receive(:parse).once.and_call_original
      2.times { response.body_json }
    end
  end

  describe "#status" do
    it "delegates the status method to the Faraday::Response object" do
      expect(response.status).to eq(200)
    end
  end
end
