# frozen_string_literal: true

require "minitest"

module Minitest
  module OpenAPI
    TestCase = Struct.new(:path)

    module RunPatch
      def run(*args)
        result = super
        return result unless ENV["DOC"]

        if self.class.document?
          test_file_path = result.source_location.first
          test_case = TestCase.new(test_file_path)

          export_file_path = Minitest::OpenAPI.path.yield_self { |p| p.is_a?(Proc) ? p.call(test_case) : p }
          endpoint_data = Minitest::OpenAPI::EndpointBuilder.call(self, test_case) || {}

          if self.webhook?
            Minitest::OpenAPI.webhooks[export_file_path] << endpoint_data
          else
            Minitest::OpenAPI.paths[export_file_path] << endpoint_data
          end
        end

        result
      end
    end
  end
end

# TODO: Refactor into its own file
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
