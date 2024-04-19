# frozen_string_literal: true

module TogglRb
  # The Params class handles the construction and validation of request parameters
  # based on a given definition. It can also serialize the processed parameters to JSON.
  class Params
    # @!attribute [rw] first_row_number
    #   @return [Integer] specify pagination row number
    attr_accessor :first_row_number

    # @!attribute [r] definition
    #   @return [Hash] the definition of parameters with their requirements and validations
    attr_reader :definition

    # @!attribute [r] request_params
    #   @return [Hash] the actual request parameters after processing
    attr_reader :request_params

    # Build a new Params object with a defined set of parameter rules and actual request parameters.
    # @param params_definition [Hash] the parameter definitions
    # @param request_params [Hash] the actual parameters passed in the request
    # @return [Params] the constructed Params object with request parameters set
    def self.build(params_definition, request_params)
      new(params_definition).tap { |p| p.request_params = request_params }
    end

    # Initialize a new Params object with a set of definitions.
    # @param params_definition [Hash] the definition of how parameters should be validated and processed
    # @see TogglRb::Param
    def initialize(params_definition = {})
      @definition = params_definition.to_h do |name, definition|
        p = Param.build(name, definition)
        [p.name, p]
      end
    end

    # Validate that all required parameters have been included in the request.
    # @raise [ArgumentError] if any required parameters are missing from the request
    def validate_required!
      missing = required_parameters.reject { |p| request_params.key?(p.name) }
      return if missing.empty?

      missing = missing.count == 1 ? "#{missing.first.name} param" : "#{missing.map(&:name).join(", ")} params"

      raise ArgumentError, "#{missing} must be provided"
    end

    # Converts the processed parameters into JSON format.
    # @param _args [Array] additional arguments, if any, for JSON generation
    # @return [String] JSON string of the processed parameters
    def to_json(*_args)
      processed_params.to_json
    end

    # Processes the raw request parameters by applying any necessary transformations such as symbolizing keys.
    # Adds pagination information if necessary.
    # @return [Hash] the processed request parameters ready for use
    def processed_params
      return request_params unless @first_row_number

      request_params[:first_row_number] = first_row_number.to_i
      request_params
    end

    # Sets the request parameters after symbolizing the keys.
    # @param params [Hash] the raw parameters passed in the request
    # @raise [ArgumentError] if the passed params contain invalid keys that cannot be symbolized
    def request_params=(params)
      @request_params = symbolize_keys(params)
    rescue NoMethodError
      raise ArgumentError, "request_params contains invalid keys"
    end

    private

    # Converts all keys in the given hash to symbols.
    # @param hash [Hash] the hash to convert
    # @return [Hash] the hash with all keys symbolized
    def symbolize_keys(hash)
      hash.transform_keys(&:to_sym)
    end

    # Retrieve all parameters from the definition that are marked as required.
    # @return [Array] an array of required parameters
    def required_parameters
      @definition.values.select(&:required?)
    end
  end
end
