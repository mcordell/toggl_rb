# frozen_string_literal: true

require "spec_helper" # Require this if you're using a spec_helper for shared configurations
require "json"

module TogglRb
  RSpec.describe JSONPatch do
    # There's a typo in your let declaration; it should be `described_class`
    let(:instance) { described_class.new }

    describe "initialization" do
      context "when not passed any arguments" do
        it "initializes with an empty operations array" do
          expect(instance.operations).to eq([])
        end
      end

      context "when passed an operations array" do
        let(:operation) { JSONPatch::Replace.new("/biscuits/1/name", "Chocolate") }
        let(:instance_with_operations) { described_class.new([operation]) }

        it "initializes with that operations array" do
          expect(instance_with_operations.operations).to eq([operation])
        end
      end
    end

    describe "#replace" do
      it "adds a replace operation and converts to JSON" do
        instance.replace("/biscuits/0/name", "Gingerbread")
        expected_json = '[{"op":"replace","path":"/biscuits/0/name","value":"Gingerbread"}]'
        expect(instance.to_json).to eq(expected_json)
      end
    end

    describe "#to_json" do
      context "when there are multiple operations" do
        it "converts all operations to JSON" do
          instance.replace("/biscuits/0/name", "Gingerbread")
          instance.replace("/biscuits/1/name", "Shortbread")
          expected_json = '[{"op":"replace","path":"/biscuits/0/name","value":"Gingerbread"},' \
                          '{"op":"replace","path":"/biscuits/1/name","value":"Shortbread"}]'
          expect(instance.to_json).to eq(expected_json)
        end
      end

      context "when there are no operations" do
        it "converts to an empty JSON array" do
          expect(instance.to_json).to eq("[]")
        end
      end
    end
  end
end
