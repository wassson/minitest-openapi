# frozen_string_literal: true

require "minitest/openapi/minitest_hook"
require "minitest/openapi/endpoint_metadata"
require "minitest/openapi/path"
require "minitest/openapi/schema"

module Minitest
  module OpenAPI
    @spec_version = "3.0.0"
    @info = {}
    @servers = []
    @path = "docs/openapi.json"
    @paths = Hash.new { |h, k| h[k] = {} }

    class << self
      attr_accessor :spec_version,
                    :info,
                    :servers,
                    :path,
                    :paths,
                    :title
    end
  end
end
