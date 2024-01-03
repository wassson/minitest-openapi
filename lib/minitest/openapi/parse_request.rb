module Minitest::OpenAPI
  module ParseRequest
    def self.call(context)
      @context = context
      [@context.request, @context.response]
    end
  end
end