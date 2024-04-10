# frozen_string_literal: true

RSpec.describe TogglRb::Params do
  let(:request_params) { { "user_id" => 123, "name" => "John Doe" } }
  let(:params_definition) do
    {
      "user_id" => { type: "integer", other_args: [:required] },
      "name" => { type: "string" }
    }
  end
  subject(:instance) { described_class.build(params_definition, request_params) }

  describe ".build" do
    context "when passed a definition and request_params" do
      subject { described_class.build(params_definition, request_params) }

      it "initializes with given definitions and sets request_params" do
        expect(subject.request_params).to eq(request_params)
      end
    end
  end

  describe "#validate_required!" do
    subject { instance.validate_required! }

    context "when all required parameters are provided" do
      let(:request_params) { { "user_id" => 123 } }

      it "does not raise an error" do
        instance.request_params =
          expect { subject }.not_to raise_error
      end
    end

    context "when some required parameters are missing" do
      let(:request_params) { { "email" => "test@example.com" } }

      it "instance an ArgumentError with a message including missing params" do
        expect { subject }.to raise_error(ArgumentError, /user_id param must be provided/)
      end
    end
  end

  describe "#to_json" do
    subject(:result) { instance.to_json }

    it "converts request_params to JSON" do
      expect(result).to eq(request_params.to_json)
    end
  end
end
