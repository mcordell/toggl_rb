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
    context "without first_row_number set" do
      it "converts request_params to JSON without altering them" do
        expect(instance.to_json).to eq(request_params.to_json)
      end
    end

    context "with first_row_number set" do
      let(:first_row_number) { 10 }
      before { instance.first_row_number = first_row_number }

      it "includes first_row_number in the JSON output" do
        expected_params = request_params.merge("first_row_number" => first_row_number)
        expect(JSON.parse(instance.to_json)).to include(expected_params)
      end
    end
  end
end
