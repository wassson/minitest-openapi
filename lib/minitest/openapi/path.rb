module Minitest
  module OpenAPI
    module Path
      TestCase = Struct.new(:path)

      def self.build(metadata, test_case)
        export_file_path = Minitest::OpenAPI.path.yield_self { |p| p.is_a?(Proc) ? p.call(test_case) : p }
        file_path_data = Minitest::OpenAPI.paths[export_file_path]

        if file_path_data[metadata[:endpoint]]
          if file_path_data[metadata[:endpoint]][metadata[:method]]
            file_path_data[metadata[:endpoint]][metadata[:method]][:responses].merge!({ metadata[:status] => self.response(metadata) })
          else
            file_path_data[metadata[:endpoint]].merge! self.format_endpoint(metadata)
          end
        else
          file_path_data.merge!(metadata[:endpoint] => self.format_endpoint(metadata))
        end
      end

      def self.format_endpoint(metadata)
        {
          metadata[:method] => {
            parameters: [],
            responses: {
              metadata[:status] => self.response(metadata),
              default: { description: "" }
            }
          }
        }
      end

      def self.response(metadata)
        {
          description: "",
          headers: {},
          content: { metadata[:content_type] => {} }
        }
      end
    end
  end
end