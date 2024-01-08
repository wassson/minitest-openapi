# frozen_string_literal: true

module Minitest
  module OpenAPI
    class InvalidFileFormat < StandardError; end

    module Schema
      def self.build
        file_paths = self.parse_files
        file_paths.each do |file|
          raise InvalidFileFormat unless valid_file_ext?(file)
          
          File.open(file, "w") do |f|
            f.write(JSON.pretty_generate(json_schema(file), indent: "  "))
            puts "File generated!"
          end
        end
      end

      # JSON.pretty_generate expects a minified JSON string even though
      # the docs state to pass in a Ruby obj.
      def self.json_schema(file)
        JSON.parse({
          openapi: Minitest::OpenAPI.version,
          info: {
            title: "minitest-openapi", # TODO: this should be the name of the app installed on
            version: Minitest::OpenAPI.version
          },
          paths: Minitest::OpenAPI.paths[file],
          webhooks: Minitest::OpenAPI.webhooks[file]
        }.to_json)
      end

      private

      def self.parse_files
        file_paths = []
        file_paths.concat(
          Minitest::OpenAPI.paths.keys, 
          Minitest::OpenAPI.webhooks.keys
        ) 
        file_paths.uniq
      end
      
      def self.valid_file_ext?(file)
        File.extname(file) == (".json" || ".yml" || ".yaml")
      end
    end
  end
end

