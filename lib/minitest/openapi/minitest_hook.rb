# frozen_string_literal: true

require 'minitest'

module Minitest::OpenAPI
  module RunPatch
    def run(*args)
      test = super
      if ENV['DOC'] && self.class.document?
        path = Minitest::OpenAPI::PathBuilder.call(self, test)
        pp path
      end
      test
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
