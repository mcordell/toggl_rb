# frozen_string_literal: true

RSpec.describe TogglRb::TimeEntry do
  subject(:instance) { described_class.new(time_entry_id) }

  let(:time_entry_id) { 3_404_802_040 }

  let(:workspace_id) { ENV.fetch("TOGGL_WORKSPACE_ID", nil) }

  describe "#initialize" do
    it "initializes with an ID" do
      time_entry = described_class.new(time_entry_id)
      expect(time_entry.id).to eq(time_entry_id)
    end
  end

  describe "attributes" do
    TogglRb::TimeEntry::API_ATTRIBUTES.each do |attr|
      it { is_expected.to respond_to(attr) }
      it { is_expected.to respond_to("#{attr}=") }
    end
  end

  describe "#body_attributes" do
    subject(:attributes) { instance.body_attributes }

    it "returns a hash of the attributes" do
      expect(attributes).to eq(
        { id: time_entry_id }
      )
    end
  end

  describe "#delete!" do
    context "when id and workspace_id are set" do
      before do
        instance.workspace_id = workspace_id
      end

      it "deletes the time entry and returns true" do
        VCR.use_cassette("delete_time_entry_success") do
          expect(instance.delete!).to be true
        end
      end
    end
  end

  describe "#update!" do
    context "when id and workspace_id are set" do
      before do
        instance.workspace_id = workspace_id
        instance.description = "UPDATE time entry"
      end

      it "sends changes to the API" do
        VCR.use_cassette("update_time_entry_success") do
          response = instance.update!
          expect(response["description"]).to eq "UPDATE time entry"
        end
      end
    end
  end

  # rubocop:disable  RSpec/MultipleExpectations
  describe "#load_attributes!" do
    it "loads attributes from the API" do
      VCR.use_cassette("get_time_entry_by_id_success") do
        instance.load_attributes!
      end
      expect(instance.description).to eq "CREATE time entry"
      expect(instance.duration).to eq 3600
    end
  end

  describe "#set_attributes" do
    let(:attrs) do
      {
        duration: 67,
        description: "a new description",
        non_existing_attr: "should not be set"
      }
    end

    it "sets attributes dynamically from a hash" do
      instance.set_attributes(attrs)

      expect(instance.duration).to eq 67
      expect(instance.description).to eq("a new description")
    end
  end
  # rubocop:enable  RSpec/MultipleExpectations
end
