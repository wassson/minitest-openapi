# frozen_string_literal: true

require 'minitest/openapi/minitest_hook'
require 'minitest/openapi/schema'

module Minitest::OpenAPI
  @path = 'docs/openapi.yaml'

  class << self
    attr_accessor :path
  end
end
