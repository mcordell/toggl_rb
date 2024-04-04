# frozen_string_literal: true

module TogglRb
  RSpec.describe Config do
    subject(:instance) { described_class.new }

    describe "#debug_logging?" do
      subject(:debug_logging) { instance.debug_logging? }

      context "when TOGGL_RB_DEBUG_LOG variable is not set" do
        it { is_expected.to eq false }
      end

      context "when TOGGL_RB_DEBUG_LOG is set to true" do
        before { allow(ENV).to receive(:fetch).with("TOGGL_RB_DEBUG_LOG", nil).and_return(true) }

        it { is_expected.to eq true }
      end
    end
  end
end
