# frozen_string_literal: true

RSpec.describe TogglRb do
  it "has a version number" do
    expect(TogglRb::VERSION).not_to be nil
  end

  describe ".client" do
    subject(:client) { described_class.client }

    it { is_expected.to be_a TogglRb::Client }
  end

  describe ".operation" do
    context "when no operations are provided" do
      it "returns a JSONPatch instance with an empty operations array" do
        json_patch_instance = TogglRb.operation
        expect(json_patch_instance).to be_a(TogglRb::JSONPatch)
        expect(json_patch_instance.operations).to eq([])
      end
    end

    context "when operations are provided" do
      it "returns a JSONPatch instance initialized with the provided operations" do
        operations = [TogglRb::JSONPatch::Replace.new("/biscuits/1/name", "Chocolate")]
        json_patch_instance = TogglRb.operation(operations)

        expect(json_patch_instance).to be_a(TogglRb::JSONPatch)
        expect(json_patch_instance.operations).to eq(operations)
      end
    end
  end
end
