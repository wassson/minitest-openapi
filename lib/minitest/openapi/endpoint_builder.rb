# frozen_string_literal: true

require 'action_dispatch'

module Minitest
  module OpenAPI
    module EndpointBuilder
      def self.call(context, _test)
        request, response = Minitest::OpenAPI::ParseRequest.call(context)
        return if request.nil?

        {
          http_method: request.method,
          status: response.status
        }
      end
    end
  end
end
