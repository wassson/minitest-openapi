# frozen_string_literal: true

require "minitest"
require "minitest/openapi/methods"

module Minitest
  module OpenAPI
    TestCase = Struct.new(:path)

    module RunPatch
      def run(*args)
        return super unless ENV["DOC"]

        binding.break

        test_file_path = super.source_location.first
        test_case = TestCase.new(test_file_path)
        metadata = Minitest::OpenAPI::EndpointMetadata.call(self, test_case) || {}

        self.webhook? ?
          Minitest::OpenAPI::Webhook.build(metadata, test_case) :
          Minitest::OpenAPI::Path.build(metadata, test_case)

        super
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
