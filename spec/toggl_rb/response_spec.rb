# frozen_string_literal: true

RSpec.describe TogglRb::Response do
  let(:headers) do
    { "server" => "nginx",
      "date" => "Thu, 11 Apr 2024 02:18:58 GMT",
      "content-type" => "application/json; charset=utf-8",
      "vary" => "Accept-Encoding",
      "x-next-id" => "4572901491",
      "x-next-row-number" => "51",
      "x-next-timestamp" => "1709585981",
      "x-page-size" => "50",
      "x-range-end" => "2024-03-31",
      "x-range-start" => "2024-03-01",
      "x-service-level" => "GREEN",
      "instance" => "track-public-api-proxy-6bc44dc6d5-7wdt5",
      "strict-transport-security" => "max-age=15552000; includeSubDomains",
      "x-frame-options" => "SAMEORIGIN",
      "x-content-type-options" => "nosniff",
      "x-we-are-hiring" => "https://toggl.com/jobs/",
      "referrer-policy" => "strict-origin-when-cross-origin",
      "content-encoding" => "gzip",
      "via" => "1.1 google",
      "alt-svc" => "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000",
      "transfer-encoding" => "chunked" }
  end
  let(:faraday_response_double) do
    instance_double(Faraday::Response, body: '{"key":"value"}', status: 200, headers: headers)
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

  describe "#more?" do
    it "returns true if 'x-next-row-number' header is present" do
      expect(response.more?).to be true
    end

    it "returns false if 'x-next-row-number' header is not present" do
      allow(faraday_response_double).to receive(:headers).and_return(headers.except("x-next-row-number"))
      expect(response.more?).to be false
    end
  end

  describe "#next_row_number" do
    it "returns the value of 'x-next-row-number' header" do
      expect(response.next_row_number).to eq("51")
    end

    it "returns nil if 'x-next-row-number' header is not present" do
      allow(faraday_response_double).to receive(:headers).and_return(headers.except("x-next-row-number"))
      expect(response.next_row_number).to be_nil
    end
  end
end
