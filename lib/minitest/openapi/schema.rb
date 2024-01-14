# frozen_string_literal: true

module Minitest
  module OpenAPI
    class InvalidFileFormat < StandardError; end

    module Schema
      ALLOWED_EXTENSIONS = %w[.json .yaml .yml].freeze

      def self.build
        file_paths = self.parse_files

        Dir.mkdir("docs") unless File.exist?("docs")
        file_paths.each do |file|
          raise InvalidFileFormat unless valid_file_ext?(file)

          File.open(file, "w") do |f|
            f.write(JSON.pretty_generate(json_schema(file), indent: "  "))
            puts "File generated!"
          end
        end
      end

      # IDK
      def self.json_schema(file)
        JSON.parse({
          openapi: "3.1.0",
          info: {
            title: Minitest::OpenAPI.title,
            version: Minitest::OpenAPI.version
          },
          servers: Minitest::OpenAPI.servers,
          paths: Minitest::OpenAPI.paths[file],
          webhooks: Minitest::OpenAPI.webhooks[file]
        }.to_json)
      end

      def self.parse_files
        file_paths = []
        file_paths.concat(
          Minitest::OpenAPI.paths.keys,
          Minitest::OpenAPI.webhooks.keys
        )
        file_paths.uniq
      end

      def self.valid_file_ext?(file)
        ALLOWED_EXTENSIONS.include?(File.extname(file))
      end
    end
  end
end
