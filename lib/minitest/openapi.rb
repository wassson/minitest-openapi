# frozen_string_literal: true

require 'minitest/openapi/minitest_hook'
require 'minitest/openapi/parse_request'
require 'minitest/openapi/path_builder'
require 'minitest/openapi/schema'

module Minitest::OpenAPI
  @path = 'docs/openapi.yaml'
  @version = '3.0.3'

  class << self
    attr_accessor :path,
                  :version
  end
end
