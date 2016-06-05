require 'spec_helper'
require 'spec_helpers/test_db'

include Txdb

describe Database, test_db: true do
  let(:database) do
    TestDb.setup do
      create_table(:foo) do
        primary_key(:id)
      end
    end
  end

  describe '#db' do
    it 'provides access to the database connection' do
      expect(database.db).to be_a(Sequel::SQLite::Database)
    end

    it 'sets the max number of connections as specified in the config' do
      expect(database.db.pool.max_size).to eq(database.pool)
    end
  end

  describe '#from' do
    it 'returns a data set to query the given table' do
      set = database.from(:foo)
      expect(set).to be_a(Sequel::Dataset)
      expect(set.sql).to eq("SELECT * FROM `foo`")
    end
  end

  describe '#transifex_api' do
    it 'grabs the api instance from the transifex project' do
      expect(database.transifex_api).to be_a(Txgh::TransifexApi)
      expect(database.transifex_api).to eq(database.transifex_project.api)
    end
  end
end
