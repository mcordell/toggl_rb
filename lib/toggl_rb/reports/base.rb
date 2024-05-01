# frozen_string_literal: true

module TogglRb
  module Reports
    class Base
      include EndpointDSL
      include RequestHelpers

      # @param connection [TogglRb::Connection] core connection to use for requests
      def initialize(connection = nil)
        @connection = connection
      end

      # @return [TogglRb::Connection] core connection to use for requests
      def connection
        @connection || TogglRb.client.reports_connection
      end
    end
  end
end
