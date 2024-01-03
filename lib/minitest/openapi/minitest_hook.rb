# frozen_string_literal: true

require 'minitest'

module Minitest
  module OpenAPI
    DESCRIPTORS = %i[path webhook component].freeze
    FileContext = Struct.new(:path)

    module RunPatch
      def run(*args)
        result = super
        return result unless ENV['DOC']

        if DESCRIPTORS.include?(self.class.document_type)
          test_file_path = result.source_location.first
          test_file_ctx = FileContext.new(test_file_path)

          export_file_path = Minitest::OpenAPI.path.yield_self { |p| p.is_a?(Proc) ? p.call(test_file_ctx) : p }
          endpoint_data = Minitest::OpenAPI::EndpointBuilder.call(self, test_file_ctx) || {}

          # TODO: Change this to work for paths or webhooks
          Minitest::OpenAPI.paths[export_file_path] << endpoint_data
        end

        result
      end
    end
  end
end

module DocumentClassMethods
  def self.prepended(base)
    base.extend(Document)
  end

  module Document
    def document_type
      @document_type
    end

    def document!(type = :path)
      @document_type = type
    end
  end
end

Minitest::Test.prepend DocumentClassMethods

if ENV['DOC']
  Minitest::Test.prepend Minitest::OpenAPI::RunPatch

  Minitest.after_run do
    puts '============================='
    puts 'Building Docs 🎉'
    puts '============================='
    puts "\n"

    pp Minitest::OpenAPI.paths
  end
end
