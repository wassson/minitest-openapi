# frozen_string_literal: true

require 'action_dispatch'

module Minitest
  module OpenAPI
    module EndpointBuilder
      class << self
        def call(context, _test)
          @request, @response = Minitest::OpenAPI::ParseRequest.call(context)
          return if @request.nil?

          endpoint = {}
          filtered_path = @request.filtered_path || 'unknown'

          # TODO: find a better name
          request_activity = activity

          endpoint[filtered_path] = request_activity
          endpoint
        end

        private

        # TODO:
        # 1. Find a better name
        # 2. Research if Minitest supports metadata
        #    (minispec-metadata/minitest-metadata/custom option)
        def activity
          {
            summary: "",
            description: "",
            status: @response.status,
            http_operation: @request.method,
            parameters: {}
          }
        end
      end
    end
  end
end
