# frozen_string_literal: true

RSpec.describe TogglRb::Param do
  describe ".build" do
    context "when other_args are provided in the definition" do
      let(:built) { described_class.build("user_id", { type: Integer, other_args: %i[required] }) }

      it "creates a new Param instance with name, type, and other_attributes" do
        expect(built.name).to eq(:user_id)
        expect(built.type).to eq(Integer)
        expect(built).to be_required
      end
    end

    context "when other_args are not provided in the definition" do
      let(:param) { described_class.build("user_id", { type: "integer" }) }

      it "creates a new Param instance with empty other_attributes" do
        expect(param.other_attributes).to be_empty
      end
    end
  end

  describe "#required?" do
    subject { instance.required? }
    context "when :required is included in other_attributes" do
      let(:instance) { described_class.new("user_id", "integer", [:required]) }

      it { is_expected.to be true }
    end

    context "when :required is not included in other_attributes" do
      let(:instance) { described_class.new("user_id", "integer", [:unique]) }

      it { is_expected.to be false }
    end
  end
end
