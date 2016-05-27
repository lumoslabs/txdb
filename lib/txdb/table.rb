require 'txgh'

module Txdb
  class Table
    attr_reader :database, :name, :columns
    attr_reader :source_lang

    def initialize(database, options = {})
      @database = database
      @name = options.fetch(:name)
      @columns = options.fetch(:columns)
      @source_lang = options.fetch(:source_lang)
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
  end
end
