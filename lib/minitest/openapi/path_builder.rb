require 'action_dispatch'

module Minitest::OpenAPI
  module PathBuilder
    def self.call(context, test)
      request, response = Minitest::OpenAPI::ParseRequest.call(context)
    end
  end
end
