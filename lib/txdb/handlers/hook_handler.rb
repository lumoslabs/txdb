require 'txgh'
require 'uri'

module Txdb
  module Handlers
    class HookHandler
      class << self
        def handle_request(request, project)
          new(request, project).handle
        end
      end

      include ResponseHelpers

      attr_reader :request, :project

      def initialize(request, project)
        @request = request
        @project = project
      end

      def handle
        locale = payload['language']

        tables.each do |table|
          content = project.api.download(table.resource, locale)
          table.write_content(content, locale)
        end

        respond_with(200, {})
      rescue => e
        respond_with_error(500, "Internal server error: #{e.message}", e)
      end

      private

      def tables
        @tables ||= Txdb::Config.each_table.select do |table|
          table.resource.resource_slug == payload['resource'] &&
            authentic_request?(table.database.transifex_project)
        end
      end

      def authentic_request?(project)
        Txgh::TransifexRequestAuth.authentic_request?(
          request, project.webhook_secret
        )
      end

      def payload
        @payload ||= begin
          request.body.rewind
          Hash[URI.decode_www_form(request.body.read)]
        end
      end
    end
  end
end
