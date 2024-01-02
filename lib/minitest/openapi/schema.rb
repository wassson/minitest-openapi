# frozen_string_literal: true

require 'yaml'

module Minitest::OpenAPI
  class InvalidFileFormat < StandardError; end

  module Schema
    def self.build
      file_path = Minitest::OpenAPI.path
      raise InvalidFileFormat unless file_path.downcase.end_with?('.yaml')

      Dir.mkdir('docs') unless File.exist?('docs')
      File.open(file_path, 'w') do |file|
        file.write(self.data.to_yaml.sub(/\A---\n/, '')) # omit the '---' separator created by .to_yaml
      end
    end

    def self.data
      {
        'openapi' => Minitest::OpenAPI.version,
        'info' => {
          'title' => 'minitest-openapi'
        },
        'paths' => {
          '/' => 'root'
        }
      }
    end

    # TODO: Handle path in test
    # rails routes | grep #{root, etc.} | awk '{print $3}'
  end
end