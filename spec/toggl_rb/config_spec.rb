# frozen_string_literal: true

module TogglRb
  RSpec.describe Config do
    subject(:instance) { described_class.new }

    describe "#debug_logging?" do
      subject(:debug_logging) { instance.debug_logging? }

      context "when TOGGL_RB_DEBUG_LOG variable is not set" do
        it { is_expected.to be false }
      end

      context "when TOGGL_RB_DEBUG_LOG is set to true" do
        before { allow(ENV).to receive(:fetch).with("TOGGL_RB_DEBUG_LOG", nil).and_return(true) }

        it { is_expected.to be true }
      end
    end

    describe "#basic_auth?" do
      subject { instance.basic_auth? }

      context "when username and password are not set" do
        it { is_expected.to be false }
      end

      context "when both username and password are set" do
        before do
          instance.username = "test_username"
          instance.password = "test_password"
        end

        it { is_expected.to be true }
      end
    end

    describe "#api_token?" do
      subject { instance.api_token? }

      context "when api_token is not set" do
        it { is_expected.to be false }
      end

      context "when api_token is set" do
        before { instance.api_token = "test_api_token" }

        it { is_expected.to be true }
      end
    end
  end
end
