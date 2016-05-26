require 'txgh'

module Txdb
  class Downloader
    class << self
      def download(database)
        new(database).download
      end
    end

    attr_reader :database

    def initialize(database)
      @database = database
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

    # project_slug, resource_slug, type, source_lang, source_file,
    # lang_map, translation_file
    def tx_resource_from(resource_hash)
      Txgh::TxResource.new(
        project_slug,
        resource_hash['slug'],
        resource_hash['i18n_type'],
        resource_hash['source_language_code'],
        resource_hash['name'],
        '', nil
      )
    end

    def process_resource?(resource, table)
      database.backend.owns_resource?(table, resource.resource_slug)
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
          tx_resource_from(resource_hash)
        end
    end
  end
end
