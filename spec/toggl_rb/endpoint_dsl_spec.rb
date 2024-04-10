# frozen_string_literal: true

class MockEndpoint
  include TogglRb::EndpointDSL

  request_path "workspace/%<workspace_id>s/search/time_entries"
  request_method :post
  param :start_date, :Date, :required, description: "should be less than end_date"
  param :end_date, :Date, description: "should be greater than start_date"
  def search_time_entries(workspace_id, params = {}); end

  request_path "projects/%<project_id>s/tasks"
  request_method :get
  param :active, :Boolean, description: "filter by task status"
  def list_project_tasks(_project_id, params = {})
    {
      params_object: build_params(params),
      request_method: request_method,
      request_path: request_path
    }
  end
end

RSpec.describe TogglRb::EndpointDSL do
  # Expanded Mock class to include multiple endpoint definitions

  let(:mock_endpoint) { MockEndpoint.new }

  describe "DSL definitions" do
    it "associates request path, method, and params with the correct endpoint method" do
      expect(MockEndpoint.method_request_paths[:search_time_entries])
        .to eq("workspace/%<workspace_id>s/search/time_entries")
      expect(MockEndpoint.method_request_methods[:search_time_entries]).to eq(:post)
      expect(MockEndpoint.param_definitions[:search_time_entries]).to include(:start_date, :end_date)

      expect(MockEndpoint.method_request_paths[:list_project_tasks]).to eq("projects/%<project_id>s/tasks")
      expect(MockEndpoint.method_request_methods[:list_project_tasks]).to eq(:get)
      expect(MockEndpoint.param_definitions[:list_project_tasks]).to include(:active)
    end

    it "provides access to the DSL definitions within the method" do
      end_point = MockEndpoint.new
      returned_method_calls = end_point.list_project_tasks(nil, {})
      expect(returned_method_calls[:request_method]).to eq :get
      expect(returned_method_calls[:request_path]).to eq "projects/%<project_id>s/tasks"
      expect(returned_method_calls[:params_object].definition.keys).to eq [:active]
    end
  end
end
