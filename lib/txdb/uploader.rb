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

    def upload_table(table)
      table.read_content.each do |resource|
        transifex_api.create_or_update(
          resource.original, resource.content
        )
      end
    end

    private

    def transifex_api
      database.transifex_api
    end
  end
end
