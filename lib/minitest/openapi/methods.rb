# frozen_string_literal: true

module Minitest
  module OpenAPI
    module Methods
      def self.prepended(base)
        base.extend(OpenAPI)

        # Response methods
        base.class_eval do
          attr_reader :response_description, :response_schema

          def description(text)
            @response_description = text
          end

          def response_schema(reference)
            @response_schema = reference
          end

          def webhook?
            @webhook
          end

          def webhook!
            @webhook = true
          end
        end
      end

      module OpenAPI
        def self.included(base)
          base.extend(ClassMethods)
        end

        # API methods
        module ClassMethods
          attr_reader :api_operation_id, :api_summary, :api_tags

          def describe_api(&block)
            class_eval &block
          end

          def operation_id(id)
            @api_operation_id = id
          end

          def summary(text)
            @api_summary = text
          end

          def tags(*tags)
            @api_tags = tags
          end
        end
      end
    end
  end
end
