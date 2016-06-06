require 'spec_helpers/env_helpers'
require 'spec_helpers/test_backend'
require 'yaml'

module Txdb
  class TestConfigurator
    class << self
      def setup(&block)
        test_config = new.tap do |test_config|
          test_config.instance_eval(&block) if block
        end

        databases << test_config.database
        databases.last
      end

      def reset_db
        databases.clear

        if File.exist?('spec/test.sqlite3')
          File.unlink('spec/test.sqlite3')
        end
      end

      def databases
        @databases ||= []
      end

      def base_config
        {
          adapter: 'sqlite',
          backend: 'test-backend',
          username: 'username',
          password: 'password',
          database: 'spec/test.sqlite3',
          transifex: {
            organization: 'myorg',
            project_slug: 'myproject',
            username: 'username',
            password: 'password',
            webhook_secret: '123abc'
          },
          tables: []
        }
      end
    end

    attr_reader :database

    def initialize
      @database = Txdb::Database.new(self.class.base_config)
    end

    def connection
      database.connection
    end

    def create_table(name, &block)
      # sequel won't create the table unless it has at least one column
      connection.create_table(name) { integer :remove_me_blarg_blarg }
      creator = TableCreator.new(name, database, &block)
      database.tables << creator.table
      connection.alter_table(name) { drop_column :remove_me_blarg_blarg }
    end
  end

  class TableCreator
    attr_reader :name, :database, :columns, :source_lang

    def initialize(name, database, &block)
      @name = name
      @database = database
      @columns = []
      @first = true
      instance_eval(&block)
    end

    def primary_key(column, *args)
      connection.alter_table(name) { add_primary_key(column, *args) }
    end

    def string(column, *args)
      add_column(column, :string, *args)
    end

    def integer(column, *args)
      add_column(column, :integer, *args)
    end

    def source_lang(lang)
      @source_lang = lang
    end

    def table
      Txdb::Table.new(
        database, {
          name: name.to_s, columns: columns, source_lang: @source_lang
        }
      )
    end

    private

    def add_column(column, type, *args)
      columns << column if translate?(args)
      connection.alter_table(name) { add_column(column, type, *args) }
    end

    def connection
      database.connection
    end

    def translate?(args)
      args.any? do |arg|
        arg.is_a?(Hash) && arg[:translate]
      end
    end
  end
end

RSpec.configure do |config|
  config.around(:each) do |example|
    Txdb::TestConfigurator.reset_db if example.metadata[:test_db]
    example.run
  end
end
