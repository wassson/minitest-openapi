# frozen_string_literal: true

require 'minitest/openapi/hooks'

module Minitest
  class Document
    @path = 'docs/openapi.yaml'

    class << self
      attr_accessor :path
    end
  end
end
