# frozen_string_literal: true

require 'yaml'

module Minitest::OpenAPI
  module Schema
    def self.build
      Dir.mkdir('docs') unless File.exists?('docs')

      File.open(Minitest::OpenAPI.path, 'w') do |file|
        file.write(self.data.to_yaml)
      end
    end

    def self.data
      {
        'minitest' => 'OpenAPI'
      }
    end
  end
end