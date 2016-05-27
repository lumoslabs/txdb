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
        return respond_with_error(401, 'Unauthorized') unless authentic_request?
        downloader.download_resource(resource, table, locale)
        respond_with(200, {})
      rescue => e
        respond_with_error(500, "Internal server error: #{e.message}", e)
      end

      private

      def downloader
        @downloader ||= Txdb::Downloader.new(database)
      end

      def database
        @database ||= Txdb::Config.databases.find do |database|
          database.transifex_project.project_slug == project_slug
        end
      end

      def table
        @table ||= database.tables.find do |table|
          database.backend.owns_resource?(table, resource)
        end
      end

      def resource
        @resource ||= Txgh::TxResource.from_api_response(
          project_slug, transifex_api.get_resource(project_slug, resource_slug)
        )
      end

      def transifex_project
        database.transifex_project
      end

      def authentic_request?
        Txgh::TransifexRequestAuth.authentic_request?(
          request, transifex_project.webhook_secret
        )
      end

      def transifex_api
        database.transifex_api
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
