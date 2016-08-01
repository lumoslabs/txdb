require 'spec_helper'
require 'spec_helpers/test_configurator'
require 'tempfile'
require 'yaml'

describe Txdb::Config do
  before(:each) do
    # clear out config before each test
    Txdb::Config.instance_variable_set(:@databases, nil)
    Txdb::Config.instance_variable_set(:@raw_config, nil)
  end

  let(:config) do
    {
      databases: [
        Txdb::TestConfigurator.base_config.tap do |base_config|
          base_config[:tables] << {
            name: 'my_table',
            columns: []
          }
        end
      ]
    }
  end

  describe '.databases' do
    it 'loads config from a string' do
      with_env('TXDB_CONFIG' => "raw://#{YAML.dump(config)}") do
        expect(Txdb::Config.databases.size).to eq(1)
        database = Txdb::Config.databases.first

        expect(database.adapter).to eq('sqlite')
        expect(database.transifex_project.organization).to eq('myorg')
        expect(database.tables.size).to eq(1)
        expect(database.tables.first.name).to eq('my_table')
      end
    end

    it 'loads config from a file' do
      file = Tempfile.new('translations')
      file.write(YAML.dump(config))
      file.flush

      with_env('TXDB_CONFIG' => "file://#{file.path}") do
        expect(Txdb::Config.databases.size).to eq(1)
        database = Txdb::Config.databases.first

        expect(database.adapter).to eq('sqlite')
        expect(database.transifex_project.organization).to eq('myorg')
        expect(database.tables.size).to eq(1)
        expect(database.tables.first.name).to eq('my_table')
      end

      file.close
      file.unlink
    end
  end

  describe '.each_table' do
    it 'returns an enumerator' do
      with_env('TXDB_CONFIG' => "raw://#{YAML.dump(config)}") do
        expect(Txdb::Config.each_table).to be_a(Enumerator)
      end
    end

    it 'yields each table in each database' do
      # set up another database with another table so we can make sure the
      # method loops over more than one db, yielding tables from each
      config[:databases] << config[:databases].first.merge(
        database: 'spec/test2.sqlite3',
        source_locale: 'en',
        tables: [
          name: 'another_table',
          columns: %w(col1 col2)
        ]
      )

      with_env('TXDB_CONFIG' => "raw://#{YAML.dump(config)}") do
        result = Txdb::Config.each_table.to_a
        expect(result.map(&:name)).to eq(%w(my_table another_table))
      end
    end
  end
end
