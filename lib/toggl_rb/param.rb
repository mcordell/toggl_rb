# frozen_string_literal: true

module TogglRb
  # Param represents the definition of an API parameter to be sent to the API
  class Param
    # @!attribute [r] name
    #   @return [Symbol] name of the parameter
    # @!attribute [r] type
    #   @return [Object] type of the parameter
    # @!attribute [r] other_attributes
    #   @return [Array<>] other attributes of the parameter
    attr_reader :name, :type, :other_attributes

    # Build a param object from the name and hash compiled by the endpoint method
    # @param name [Symbol|String] name of the parameter
    # @param definition [Hash] description of var
    # @option definition [Mixed] :type type of the param that will be sent to the api
    # @option definition [Array] :other_args other attributes of the param
    def self.build(name, definition)
      new(
        name,
        definition.fetch(:type),
        definition.fetch(:other_args, [])
      )
    end

    # @param name [Symbol|String] name of the parameter
    # @param type [Mixed] type of the param that will be send to the API
    # @param other_attributes [Array<Mixed>] other attributes on this param
    def initialize(name, type, other_attributes = [])
      @name = name.to_sym
      @type = type
      @other_attributes = other_attributes
    end

    # @return [Boolean] whether this param is required for the end point
    def required?
      @other_attributes.include?(:required)
    end
  end
end
