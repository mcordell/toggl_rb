# frozen_string_literal: true

RSpec.describe TogglRb::Workspace do
  subject(:instance) { described_class.new(workspace_id) }

  let(:workspace_id) { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }

  describe "#initialize" do
    it "initializes with an ID" do
      workspace = described_class.new(workspace_id)
      expect(workspace.id).to eq(workspace_id)
    end
  end

  describe "attributes" do
    TogglRb::Workspace::API_ATTRIBUTES.each do |attr|
      it { is_expected.to respond_to(attr) }
      it { is_expected.to respond_to("#{attr}=") }
    end
  end

  # rubocop:disable  RSpec/MultipleExpectations
  describe "#load_attributes!" do
    it "loads attributes from the API" do
      VCR.use_cassette("get_workspace_success") do
        instance.load_attributes!
      end
      expect(instance.admin).to be true
      expect(instance.name).to eq "toggltest's workspace"
    end
  end

  describe "#set_attributes" do
    let(:attrs) do
      {
        admin: true,
        api_token: "def456",
        non_existing_attr: "should not be set"
      }
    end

    it "sets attributes dynamically from a hash" do
      instance.set_attributes(attrs)

      expect(instance.admin).to be(true)
      expect(instance.api_token).to eq("def456")
    end
  end
  # rubocop:enable  RSpec/MultipleExpectations
end
