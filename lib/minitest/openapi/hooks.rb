# frozen_string_literal: true

module Minitest
  module OpenAPI
    class Hooks
      def self.hello
        puts 'Hello from MiniTest::Hooks!'
      end
    end
  end
end
