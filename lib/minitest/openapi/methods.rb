# frozen_string_literal: true

module MiniAPI
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
      @pending_summary = text
    end

    # This hook runs every time a method is added to the class
    def method_added(method_name)
      return unless @pending_summary

      @summaries ||= {}
      @summaries[method_name] = @pending_summary

      puts @pending_summary
      @pending_summary = nil
    end

    def get_summary(method_name)
      @summaries&.[](method_name)
    end

    def tags(*tags)
      @api_tags = tags
    end
  end
end

module Minitest
  module OpenAPI
    module Methods
      def self.prepended(base)
        base.extend(MiniAPI)

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

    end
  end
end
