require 'txgh'

module Txdb
  class Table
    attr_reader :database, :name, :columns
    attr_reader :source_lang

    def initialize(database, options = {})
      @database = database
      @name = options.fetch(:name)
      @source_lang = options.fetch(:source_lang)
      @columns = options.fetch(:columns).map do |column_config|
        Column.new(self, column_config)
      end
    end

    def db
      database.db.from(name)
    end

    def read_content
      database.backend.read_content_from(self)
    end

    def write_content(resource, locale)
      database.backend.write_content_to(self, resource, locale)
    end

    def find_column(name)
      columns.find { |col| col.name == name }
    end
  end
end
