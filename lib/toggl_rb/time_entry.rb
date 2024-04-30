# frozen_string_literal: true

module TogglRb
  # TimeEntry is an object that represents a Toggl TimeEntry
  class TimeEntry
    API_ATTRIBUTES = %i[
      billable
      created_with
      description
      duration
      project_id
      shared_with_user_ids
      start
      start_date
      stop
      tag_ids
      tags
      task_id
      user_id
      workspace_id
    ].freeze

    UNSET = Object.new.freeze

    # @!attribute [rw] id
    #   @return [Integer] the ID of the time entry
    # @!attribute [rw] workspace_id
    #   @return [Integer] the workspace id this time entry belongs t
    attr_accessor :id, *API_ATTRIBUTES

    # @param id [Integer] the id of the time entry
    def initialize(id)
      @id = id
      API_ATTRIBUTES.each { |k| send(:"#{k}=", UNSET) }
    end

    def update!
      TogglRb::Core::TimeEntries.new.update(workspace_id, id, body_attributes)
    end

    def delete!
      TogglRb::Core::TimeEntries.new.delete(workspace_id, id)
    end

    # Load attributes from the API, will set attributes on this instance from the API
    # @return [TogglRb::TimeEntry] self
    def load_attributes!
      json = TogglRb::Core::TimeEntries.new.get(id)

      set_attributes(json)
    end

    # @return [Hash] attributes for making a request
    def body_attributes
      hsh = API_ATTRIBUTES.to_h do |k|
        [k, send(k)]
      end
      hsh.reject! { |_k, v| v == UNSET }
      hsh.merge(id: id)
    end

    # rubocop:disable Naming/AccessorMethodName
    # @param attrs [Hash] attributes to set on this instance
    # @return [TogglRb::TimeEntry] self
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
