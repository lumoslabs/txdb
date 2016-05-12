module GlobalizeDb
  class << self
    def db
      @db ||= Sequel.connect("sqlite://#{db_path}")
    end

    def database
      @database ||= Txdb::Database.new(
        adapter: 'sqlite',
        backend: Txdb::Backends.get('globalize'),
        username: 'username',
        password: 'password',
        database: db_path,
        transifex: {
          organization: 'myorg',
          project_slug: 'myproject',
          username: 'username',
          password: 'password'
        },
        tables: [{
          name: 'widget_translations',
          source_lang: 'en',
          columns: %w(name)
        }]
      )
    end

    def db_path
      File.join(File.dirname(__FILE__), '../test.sqlite3')
    end

    def reset_db
      db.tables.each { |t| db.drop_table(t) }
      setup_db
    end

    def setup_db
      db.create_table(:widgets) do
        primary_key :id
        string :name
      end

      db.create_table(:widget_translations) do
        primary_key :id
        integer :widget_id
        string :locale
        string :name
      end
    end

    def widgets
      db[:widgets]
    end

    def widget_translations
      db[:widget_translations]
    end

    def widget_translations_table
      database.tables.find do |table|
        table.name == 'widget_translations'
      end
    end
  end
end

RSpec.shared_context(:globalize) do
  let(:widgets) { GlobalizeDb.widgets }
  let(:widget_translations) { GlobalizeDb.widget_translations }
  let(:widget_translations_table) { GlobalizeDb.widget_translations_table }
  let(:database) { GlobalizeDb.database }
end

RSpec.configure do |config|
  config.before(:all) do
    GlobalizeDb.reset_db
  end

  config.around(:each) do |example|
    begin
      example.run
    ensure
      GlobalizeDb.reset_db if example.metadata[:globalize]
    end
  end
end
