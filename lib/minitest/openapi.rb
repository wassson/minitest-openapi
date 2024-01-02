# frozen_string_literal: true

require 'minitest/openapi/hooks'

module Minitest::OpenAPI
  @path = 'docs/openapi.yaml'

  class << self
    attr_accessor :path
  end
end
