# frozen_string_literal: true

module TogglRb
  module Core
    class Base
      include EndpointDSL
      include RequestHelpers

      # @param connection [TogglRb::Connection] core connection to use for requests
      def initialize(connection = nil)
        @connection = connection
      end

      # @return [TogglRb::Connection] core connection to use for requests
      def connection
        @connection || TogglRb.client.core_connection
      end
    end
  end
end
