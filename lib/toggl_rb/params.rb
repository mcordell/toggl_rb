# frozen_string_literal: true

module TogglRb
  class Params
    attr_accessor(:request_params, :first_row_number)
    attr_reader :definition

    def self.build(params_definition, request_params)
      new(params_definition).tap { |p| p.request_params = request_params }
    end

    def initialize(params_definition = {})
      @definition = params_definition.to_h do |name, definition|
        p = Param.build(name, definition)
        [p.name, p]
      end
    end

    def validate_required!
      missing = required_parameters.reject { |p| request_params.key?(p.name) }
      return if missing.empty?

      missing = missing.count == 1 ? "#{missing.first.name} param" : "#{missing.map(&:name).join(", ")} params"

      raise ArgumentError, "#{missing} must be provided"
    end

    def to_json(*_args)
      processed_params.to_json
    end

    def processed_params
      return request_params unless @first_row_number

      request_params[:first_row_number] = first_row_number.to_i
      request_params
    end

    private

    def required_parameters
      @definition.values.select(&:required?)
    end
  end
end
