# frozen_string_literal: true

require "minitest"

module Minitest
  module OpenAPI
    TestCase = Struct.new(:path)

    module RunPatch
      def run(*args)
        return super unless ENV["DOC"]
        result = super

        if self.class.document?
          test_file_path = result.source_location.first
          test_case = TestCase.new(test_file_path)
          metadata = Minitest::OpenAPI::EndpointMetadata.call(self, test_case) || {}

          self.webhook? ?
            Minitest::OpenAPI::Webhook.build(metadata, test_case) :
            Minitest::OpenAPI::Path.build(metadata, test_case)
        end

        result
      end
    end
  end
end

module MinitestOpenAPIMethods
  def self.prepended(base)
    base.extend(Document)

    base.class_eval do
      def webhook?
        @webhook
      end

      def webhook!
        @webhook = true
      end
    end
  end

  module Document
    def document?
      @document
    end

    def document!
      @document = true
    end
  end
end

Minitest::Test.prepend MinitestOpenAPIMethods

if ENV["DOC"]
  Minitest::Test.prepend Minitest::OpenAPI::RunPatch

  Minitest.after_run do
    Minitest::OpenAPI::Schema.build
  end
end
