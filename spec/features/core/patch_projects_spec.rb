# frozen_string_literal: true

RSpec.describe "Core - V9 - Bulk edit multiple projects", type: :feature do
  let(:api) { TogglRb::Core::Projects.new }

  let(:operation) { TogglRb.operation.replace("/color", "#000000") }
  let(:projects) { [201_899_518, 201_876_878] }

  describe "PATCH api/v9/workspaces/{workspace_id}/projects/{project_ids}" do
    context "when passed a workspace id, an array of projects and an operation" do
      it "runs the operation successfully" do
        VCR.use_cassette("bulk_patch_projects_success") do
          response = api.patch(workspace_id, projects, operation)

          expect(response).to match({ "success" => be_a(Array), "failure" => be_a(Array) })

          expect(response["success"].count).to eq 2
        end
        VCR.use_cassette("get_projects_after_bulk_update_success") do
          response = api.search(workspace_id)
          colors = response.filter_map { |p| p["color"] if projects.include?(p["id"]) }
          expect(colors).to match(["#000000", "#000000"])
        end
      end
    end
  end
end
