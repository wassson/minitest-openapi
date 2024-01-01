# frozen_string_literal: true

require 'minitest/openapi/hooks'

module Minitest
  class Config
    @path = 'docs/openapi.yaml'

    class << self
      attr_accessor :path
    end
  end
end
