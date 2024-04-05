# frozen_string_literal: true

module TogglRb
  RSpec.describe Client do
    subject(:instance) { described_class.new }

    describe "#base_connection" do
      subject(:debug_logging) { instance.base_connection }

      it { is_expected.to be_a(Faraday::Connection) }
    end
  end
end
