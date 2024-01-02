# frozen_string_literal: true

require 'minitest'

module Minitest
  module OpenAPI
    module RunPatch
      def run(*args)
        result = super
        if ENV['DOC'] && self.class.openapi?
          # This will run before specs
        end
        result
      end
    end

    module ActivateOpenApiClassMethods
      def self.prepended(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def openapi?
          @openapi
        end

        def openapi!
          @openapi = true
        end
      end
    end
  end
end

Minitest::Test.prepend Minitest::OpenAPI::ActivateOpenApiClassMethods

if ENV['DOC']
  Minitest::Test.prepend Minitest::OpenAPI::RunPatch
  Minitest.after_run do
    puts "============================="
    puts "Building Docs 🎉"
    puts "============================="
  end
end

