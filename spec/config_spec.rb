require 'spec_helper'
require 'spec_helpers/test_db'
require 'tempfile'
require 'yaml'

describe Txdb::Config do
  describe '#databases' do
    it 'loads config from a string' do
      with_env('TXDB_CONFIG' => "raw://#{YAML.dump(TestDb.raw_config)}") do
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
      file.write(YAML.dump(TestDb.raw_config))
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
end
