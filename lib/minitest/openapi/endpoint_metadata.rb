# frozen_string_literal: true

require "action_dispatch"
require "active_support/inflector"

module Minitest
  module OpenAPI
    module EndpointMetadata
      class << self
        def call(context, _test)
          @request = context.request
          @response = context.response
          return if @request.nil?

          @endpoint = @request.filtered_path || "unknown"
          metadata
        end

        private

        def metadata
          {
            endpoint: format_endpoint,
            method: @request.method.downcase,
            parameters: @request.env["action_dispatch.request.parameters"],
            summary: "",
            status: @response.status,
            content_type: @request.env["CONTENT_TYPE"]
          }
        end

        # TODO: Rails.application.routes.recognize_path(request.path)
        # Convert "owners/1234/pets/5678" to "owners/{ownerId}/pets/{petId}"
        def format_endpoint
          ep = @endpoint.split("/")[1..-1] || []
          resource = ""

          ep.each_with_index do |e, i|
            i.odd? ?
              ep[i] = "{#{resource}Id}" :
              resource = ActiveSupport::Inflector.singularize(e)
          end
          "/#{ep.join("/")}"
        end
      end
    end
  end
end
