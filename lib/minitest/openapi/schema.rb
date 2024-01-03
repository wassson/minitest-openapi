# frozen_string_literal: true

module Minitest::OpenAPI
  class InvalidFileFormat < StandardError; end

  module Schema
    def self.build
      file_path = Minitest::OpenAPI.path
      raise InvalidFileFormat unless file_path.downcase.end_with?('.json')

      Dir.mkdir('docs') unless File.exist?('docs')
      File.open(file_path, 'w') do |file|
        file.write(JSON.pretty_generate(self.json_schema, indent: '  '))
      end
    end

    # JSON.pretty_generate expects a minified JSON string even though
    # the docs state to pass in a Ruby obj.
    def self.json_schema
      JSON.parse({
        openapi: Minitest::OpenAPI.version,
        info: {
          title: 'minitest-openapi',
          version: '0.0.1'
        },
        paths: {},
        webhooks: {}
      }.to_json)
    end

    # TODO: Handle path from test
    # rails routes | grep #{root, etc.} | awk '{print $3}'
  end
end