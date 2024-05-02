# frozen_string_literal: true

RSpec.describe "Core - V9 - Delete project", type: :feature do
  let(:api) {  TogglRb::Core::Projects.new }

  let(:project_id) { 202_440_103 }

  describe "DELETE api/v9/workspaces/{workspace_id}/projects/{project_id}" do
    context "when updating a project with id and workspace id" do
      it "successfully delete the project" do
        VCR.use_cassette("delete_project_success") do
          response = api.delete(workspace_id, project_id)

          expect(response).to be true
        end
      end
    end
  end
end
