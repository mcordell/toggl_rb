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
  end
end
