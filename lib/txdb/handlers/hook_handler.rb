require 'txgh'
require 'uri'

module Txdb
  module Handlers
    class HookHandler
      class << self
        def handle_request(request)
          new(request).handle
        end
      end

      include ResponseHelpers

      attr_reader :request

      def initialize(request)
        @request = request
      end

      def handle
        if authentic_request?
          downloader.download_resource(resource)
          respond_with(200, {})
        else
          respond_with(401, 'Unauthorized')
        end
      rescue => e
        respond_with_error(500, "Internal server error: #{e.message}", e)
      end

      private

      def downloader
        @downloader ||= Txdb::Downloader.new(table.database)
      end

      def table
        @table ||= Txdb::Config.each_table.find do |table|
          table.database.backend.owns_resource?(table, resource)
        end
      end

      def resource
        @resource ||= Txdb::TxResource.from_api_response(
          transifex_api.get_resource(project_slug, resource_slug)
        )
      end

      def transifex_project
        table.database.transifex_project
      end

      def authentic_request?
        Txgh::TransifexRequestAuth.authentic_request?(
          request, transifex_project.webhook_secret
        )
      end

      def transifex_api
        table.database.transifex_api
      end

      def project_slug
        payload['project']
      end

      def resource_slug
        payload['resource']
      end

      def locale
        payload['language']
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
