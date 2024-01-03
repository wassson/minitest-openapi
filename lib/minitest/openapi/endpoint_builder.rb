# frozen_string_literal: true

require 'action_dispatch'

module Minitest
  module OpenAPI
    module EndpointBuilder
      def self.call(context, _test)
        request, response = Minitest::OpenAPI::ParseRequest.call(context)
        return if request.nil?

        endpoint = {}
        filtered_path = request.filtered_path || 'unknown'
        request_activity = { http_method: request.method, status: response.status }

        endpoint[filtered_path] = request_activity
        endpoint
      end
    end
  end
end
