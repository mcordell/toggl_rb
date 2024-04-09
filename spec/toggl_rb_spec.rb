# frozen_string_literal: true

RSpec.describe TogglRb do
  it "has a version number" do
    expect(TogglRb::VERSION).not_to be nil
  end

  describe ".client" do
    subject(:client) { described_class.client }

    it { is_expected.to be_a TogglRb::Client }
  end
end
