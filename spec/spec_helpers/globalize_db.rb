require 'spec_helpers/test_db'

class GlobalizeDb < TestDb
  class << self
    def database
      @database ||= Txdb::Database.new(
        raw_config[:databases].first.merge(
          backend: Txdb::Backends.get('globalize'),
          tables: [{
            name: 'widget_translations',
            source_lang: 'en',
            columns: %w(name)
          }]
        )
      )
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
  config.around(:each) do |example|
    GlobalizeDb.reset_db if example.metadata[:globalize_db]
    example.run
  end
end
