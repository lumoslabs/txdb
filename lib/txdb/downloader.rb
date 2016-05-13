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
      content = transifex_api.download(table.resource, locale)
      table.write_content(content, locale)
    end

    private

    def transifex_api
      database.transifex_api
    end
  end
end
