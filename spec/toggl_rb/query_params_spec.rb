# frozen_string_literal: true

module TogglRb
  RSpec.describe QueryParams do
    let(:definition) { {} }

    subject(:instance) { described_class.new(definition) }

    describe "#build_url" do
      let(:base_path) { "/api" }

      subject(:built_url) { instance.build_url(base_path) }
      context "when passed a base_path with set query_params" do
        it "constructs a URL with the given base path and set request params" do
          instance.request_params = { "key1" => "value1", "key2" => "value2" }
          expect(built_url).to eq("/api?key1=value1&key2=value2")
        end
      end

      context "when passed a base_path and request_params is empty" do
        before { instance.request_params = {} }

        it "returns the unmodified base_path" do
          expect(built_url).to eq base_path
        end
      end

      context "when passed a base_path and request_params contains special characters" do
        before { instance.request_params = { "key1" => "value with spaces", "key2" => "special&chars" } }

        it "encodes special characters in then query parameters" do
          expect(built_url).to eq("/api?key1=value+with+spaces&key2=special%26chars")
        end
      end
    end
  end
end
