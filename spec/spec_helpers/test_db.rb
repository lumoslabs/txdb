require 'spec_helpers/env_helpers'
require 'spec_helpers/test_backend'
require 'yaml'

class TestDb
  class << self
    def db
      @db ||= database.db
    end

    def database
      @database ||= Txdb::Database.new(raw_config[:databases].first)
    end

    def db_path
      File.join(File.dirname(__FILE__), '../test.sqlite3')
    end

    def raw_config
      @config ||= deep_freeze({
        databases: [{
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
          tables: [{
            name: 'my_table',
            source_lang: 'en',
            columns: [
              { name: 'my_column', type: 'string' }
            ]
          }]
        }]
      })
    end

    def reset_db
      db.tables.each { |t| db.drop_table(t) }
      setup_db
    end

    def setup_db
      # no-op
    end

    private

    def deep_freeze(obj)
      case obj
        when Hash
          obj.each_with_object({}) do |(k, v), ret|
            ret[k] = deep_freeze(v)
          end.freeze

        when Array
          obj.map { |elem| deep_freeze(elem) }.freeze

        else
          obj
      end
    end
  end
end

RSpec.configure do |config|
  config.around(:each) do |example|
    TestDb.reset_db if example.metadata[:test_db]
    example.run
  end
end
