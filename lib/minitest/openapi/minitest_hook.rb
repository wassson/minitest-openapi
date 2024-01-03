# frozen_string_literal: true

require 'minitest'

module Minitest::OpenAPI
  FileContext = Struct.new(:path)

  module RunPatch
    def run(*args)
      result = super
      if ENV['DOC'] && self.class.document?
        file_path = result.source_location.first
        file_ctx = FileContext.new(file_path)
        export_file_path = Minitest::OpenAPI.path.yield_self { |p| p.is_a?(Proc) ? p.call(file_ctx) : p }
        endpoint_data = Minitest::OpenAPI::EndpointBuilder.call(self, file_ctx)
        Minitest::OpenAPI.paths[export_file_path] << endpoint_data
      end
      result
    end
  end
end

module DocumentClassMethods
  def self.prepended(base)
    base.extend(Document)
  end

  module Document
    def document?
      @document
    end

    def document!
      @document = true
    end

    # TODO: webhooks
    # def webhook?
    #   @webhook
    # end
    #
    # def webhook!
    #   @webhook = true
    # end
  end
end

Minitest::Test.prepend DocumentClassMethods

if ENV['DOC']
  Minitest::Test.prepend Minitest::OpenAPI::RunPatch

  Minitest.after_run do
    puts "============================="
    puts "Building Docs 🎉"
    puts "============================="
  end
end
