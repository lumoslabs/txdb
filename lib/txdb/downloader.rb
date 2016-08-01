require 'txgh'

module Txdb
  class Downloader
    class << self
      def download(database, locale)
        new(database).download(locale)
      end

      def download_all(database)
        new(database).download_all
      end
    end

    attr_reader :database

    def initialize(database)
      @database = database
    end

    def download_all
      database.tables.each do |table|
        database.locales.each do |locale|
          next if locale == database.source_locale
          download_table(table, locale)
        end
      end
    end

    def download(locale)
      database.tables.each do |table|
        download_table(table, locale)
      end
    end

    def download_table(table, locale)
      resources.each do |tx_resource|
        next unless process_resource?(tx_resource, table)
        download_resource(tx_resource, table, locale)
      end
    end

    def download_resource(tx_resource, table, locale)
      content = transifex_api.download(tx_resource, locale)
      resource = Txdb::TxResource.new(tx_resource, content)
      table.write_content(resource, locale)
    end

    private

    def process_resource?(resource, table)
      database.backend.owns_resource?(table, resource)
    end

    def project_slug
      database.transifex_project.project_slug
    end

    def transifex_api
      database.transifex_api
    end

    def resources
      @resources ||= transifex_api
        .get_resources(project_slug)
        .map do |resource_hash|
          Txgh::TxResource.from_api_response(project_slug, resource_hash)
        end
    end
  end
end
