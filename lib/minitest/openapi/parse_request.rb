module Minitest::OpenAPI
  module ParseRequest
    # TODO: Add support for Rack::Test for middleware/etc.
    def self.call(context)
      @context = context
      [@context.request, @context.response]
    end
  end
end