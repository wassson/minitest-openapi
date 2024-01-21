# frozen_string_literal: true

require "minitest"
require "minitest/openapi/methods"

module Minitest
  module OpenAPI
    TestCase = Struct.new(:path)

    module RunPatch
      def run(*args)
        return super unless ENV["DOC"]
        result = super

        binding.b

        test_file_path = result.source_location.first
        test_case = TestCase.new(test_file_path)
        metadata = Minitest::OpenAPI::EndpointMetadata.call(self, test_case) || {}

        self.webhook? ?
          Minitest::OpenAPI::Webhook.build(metadata, test_case) :
          Minitest::OpenAPI::Path.build(metadata, test_case)

        result
      end
    end
  end
end

Minitest::Test.prepend Minitest::OpenAPI::Methods

if ENV["DOC"]
  Minitest::Test.prepend Minitest::OpenAPI::RunPatch

  Minitest.after_run do
    Minitest::OpenAPI::Schema.build
  end
end
