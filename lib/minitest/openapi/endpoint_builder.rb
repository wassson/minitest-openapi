require 'action_dispatch'

module Minitest::OpenAPI
  module EndpointBuilder
    def self.call(context, test)
      request, response = Minitest::OpenAPI::ParseRequest.call(context)
      {
        http_method: request.method,
        status: response.status
      }
    end
  end
end
