# frozen_string_literal: true

module TogglRb
  class Param
    attr_reader :name, :type, :other_attributes

    def self.build(name, definition)
      new(
        name,
        definition.fetch(:type),
        definition.fetch(:other_args, [])
      )
    end

    def initialize(name, type, other_attributes = [])
      @name = name
      @type = type
      @other_attributes = other_attributes
    end

    def required?
      @other_attributes.include?(:required)
    end
  end
end
