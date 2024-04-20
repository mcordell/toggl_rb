# frozen_string_literal: true

RSpec.describe TogglRb::Params do
  subject(:instance) { described_class.build(params_definition, request_params) }

  let(:request_params) { { "user_id" => 123, "name" => "John Doe" } }
  let(:params_definition) do
    {
      "user_id" => { type: "integer", other_args: [:required] },
      "name" => { type: "string" }
    }
  end

  describe ".build" do
    context "when passed a definition and request_params" do
      subject { described_class.build(params_definition, request_params) }

      it "initializes with given definitions and sets request_params" do
        expect(subject.request_params).to eq(request_params.transform_keys(&:to_sym))
      end
    end
  end

  describe "request_params=" do
    subject { instance.request_params = request_params }

    context "when passed a hash" do
      context "with string keys" do
        it "symbolizes the keys" do
          expect(instance.request_params.keys).to match(%i[user_id name])
        end
      end

      context "when passed a hash with neither string nor symbol keys" do
        let(:request_params) { { Date.new(2024, 2, 1) => "date_value" } }

        it "raises an ArgumentError" do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end

  describe "#validate_required!" do
    subject { instance.validate_required! }

    context "when all required parameters are provided" do
      let(:request_params) { { "user_id" => 123 } }

      it "does not raise an error" do
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
