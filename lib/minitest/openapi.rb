# frozen_string_literal: true

require 'minitest/openapi/minitest_hook'
require 'minitest/openapi/parse_request'
require 'minitest/openapi/endpoint_builder'
require 'minitest/openapi/schema'

module Minitest
  module OpenAPI
    @path = 'docs/openapi.yaml'
    @paths = Hash.new { |h, k| h[k] = [] }
    @version = '3.0.3'
    @webhooks = Hash.new { |h, k| h[k] = [] }

    class << self
      attr_accessor :path,
                    :paths,
                    :version,
                    :webhooks
    end
  end
end
