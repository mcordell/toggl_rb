# frozen_string_literal: true

module TogglRb
  # A class for creating and managing JSON Patch documents.
  class JSONPatch
    # Represents a single operation within a JSON Patch document.
    class Operation
      attr_accessor(:type, :path, :value)

      # @!attribute [rw] type
      #   @return [String] the operation type (add, remove, replace, etc.)
      # @!attribute [rw] path
      #   @return [String] the JSON Pointer path to the location where the operation will occur
      # @!attribute [rw] value
      #   @return [Object] the value used in the operation (optional for remove)

      # Initializes a new operation.
      # @param type [String] The operation type.
      # @param path [String] The JSON Pointer path.
      # @param value [Object] The value to be used with the operation.
      def initialize(type, path, value)
        @type = type
        @path = path
        @value = value
      end

      # Converts the operation to a hash suitable for JSON serialization.
      # @return [Hash] The operation as a hash.
      def to_h
        { "op" => type, "path" => path, "value" => value }
      end
    end

    # A specialized Operation for replacing values on objects via JSON Patch
    class Replace < Operation
      # Initializes a replace operation.
      # @param path [String] The JSON Pointer path to the value being replaced.
      # @param value [Object] The new value to assign.
      def initialize(path = nil, value = nil)
        super("replace", path, value)
      end
    end

    # @!attribute [r] operations
    #   @return [Array<Operation>] the list of operations included in the JSON Patch
    attr_reader :operations

    # Initializes a new JSONPatch document.
    # @param operations [Array<Operation>] A list of operations to be included in the patch.
    def initialize(operations = [])
      @operations = operations
    end

    # Converts the list of operations to a JSON string.
    # @param _args [Array] Additional arguments, ignored in this method.
    # @return [String] JSON representation of the operations.
    def to_json(*_args)
      operations.map(&:to_h).to_json
    end

    # Adds a replace operation to the JSON Patch.
    # @param path [String] The JSON Pointer path to the value being replaced.
    # @param value [Object] The new value to assign.
    # @return [JSONPatch] Returns self to allow chaining.
    def replace(path, value)
      operations.push(Replace.new(path, value))
      self
    end
  end
end
