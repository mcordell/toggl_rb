# frozen_string_literal: true

module TogglRb
  class JSONPatch
    # frozen_string_literal: true
    class Operation
      attr_accessor(:type, :path, :value)

      def initialize(type, path, value)
        @type = type
        @path = path
        @value = value
      end

      def to_h
        { "op" => type, "path" => path, "value" => value }
      end
    end

    class Replace < Operation
      def initialize(path = nil, value = nil)
        super("replace", path, value)
      end
    end

    attr_reader :operations

    def initialize(operations = [])
      @operations = operations
    end

    def to_json(*_args)
      operations.map(&:to_h).to_json
    end

    def replace(path, value)
      operations.push(Replace.new(path, value))
      self
    end
  end
end
