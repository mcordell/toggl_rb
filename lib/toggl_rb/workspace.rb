# frozen_string_literal: true

module TogglRb
  # A workspace object corresponds to the a Toggl workspace. This is an entry
  # point for many API endpoints since many methods require a workspace ID
  class Workspace
    # @!attribute [r] id
    #   @return [Integer] the workspace's ID
    attr_reader :id

    API_ATTRIBUTES = %i[admin api_token at business_ws csv_upload default_currency
                        default_hourly_rate hide_start_end_times ical_enabled ical_url
                        last_modified logo_url name only_admins_may_create_projects
                        only_admins_may_create_tags only_admins_see_billable_rates
                        only_admins_see_team_dashboard organization_id permissions premium
                        profile projects_billable_by_default projects_private_by_default
                        rate_last_updated reports_collapse role rounding rounding_minutes
                        server_deleted_at subscription suspended_at working_hours_in_minutes].freeze

    attr_accessor(*API_ATTRIBUTES)

    # @param id [Integer] the workspace's ID
    def initialize(id)
      @id = id
    end

    # Load attributes from the API, will set attributes on this instance from the API
    # @return [TogglRb::Workspace] self
    def load_attributes!
      json = TogglRb::Core::Workspaces.new.get(id)

      set_attributes(json)
    end

    # rubocop:disable Naming/AccessorMethodName
    # @param attrs [Hash] attributes to set on this instance
    # @return [TogglRb::Workspace] self
    def set_attributes(attrs)
      attrs.each do |k, v|
        next unless API_ATTRIBUTES.include?(k.to_sym)

        send(:"#{k}=", v)
      end
      self
    end
    # rubocop:enable Naming/AccessorMethodName
  end
end
