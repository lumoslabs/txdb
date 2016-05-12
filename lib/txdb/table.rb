require 'txgh'
require 'yaml'

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

    def resource
      @resource ||= Txdb::TxResource.from_table(self)
    end

    def read_content
      YAML.dump(
        database.backend.read_content_from(self)
      )
    end

    def write_content(content, locale)
      database.backend.write_content_to(
        self, YAML.load(content), locale
      )
    end
  end
end
