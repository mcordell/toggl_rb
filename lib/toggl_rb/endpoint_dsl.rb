# frozen_string_literal: true

module TogglRb
  module EndpointDSL
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      ALLOWED_METHOD_TYPES = %i[post get put patch].freeze
      ALLOWED_PRETTY = ALLOWED_METHOD_TYPES.map { |s| ":#{s}" }.join(", ").freeze

      def method_added(method_name)
        return if @adding_method || !@current_path

        param_definitions[method_name] = @current_params || {}
        method_request_paths[method_name] = @current_path
        method_request_methods[method_name] = @current_method_type
        @current_params = nil # Reset for the next method
        @current_path = nil
        @current_method_type = nil
        super
      end

      def request_path(path)
        @current_path = path
      end

      def request_method(method_type)
        method_type = method_type.to_sym
        return @current_method_type = method_type if ALLOWED_METHOD_TYPES.include?(method_type)

        raise ArgumentError, "method type: #{method_type} is not one of #{ALLOWED_PRETTY}"
      end

      def param_definitions
        @param_definitions ||= {}
      end

      def method_request_paths
        @method_request_paths ||= {}
      end

      def method_request_methods
        @method_request_methods ||= {}
      end

      def param(name, type, *other_args)
        @current_params ||= {}
        @current_params[name] = { type: type, other_args: other_args }
      end
    end

    def params_for_method(method_name)
      self.class.param_definitions[method_name] || {}
    end

    def build_params(request_params)
      caller_info = caller_locations(1, 1).first
      Params.build(params_for_method(caller_info.label.to_sym), request_params)
    end

    def request_path
      caller_info = caller_locations(1, 1).first
      self.class.method_request_paths.fetch(caller_info.label.to_sym)
    end

    def request_method
      caller_info = caller_locations(1, 1).first
      self.class.method_request_methods.fetch(caller_info.label.to_sym)
    end
  end
end
