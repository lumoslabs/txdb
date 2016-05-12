module Txdb
  class Uploader
    class << self
      def upload(database)
        new(database).upload
      end
    end

    attr_reader :database

    def initialize(database)
      @database = database
    end

    def upload
      database.tables.each do |table|
        upload_table(table)
      end
    end

    private

    def upload_table(table)
      transifex_api.create_or_update(
        table.resource, table.read_content
      )
    end

    def transifex_api
      database.transifex_api
    end
  end
end
