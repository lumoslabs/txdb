require 'spec_helper'
require 'spec_helpers/test_db'
require 'yaml'

include Txdb

describe Table, test_db: true do
  let(:database) { TestDb.database }
  let(:table) { database.tables.first }

  describe '#db' do
    it 'returns a dataset primed to select from the table' do
      expect(table.db).to be_a(Sequel::Dataset)
      expect(table.db.sql).to eq('SELECT * FROM `my_table`')
    end
  end

  describe '#read_content' do
    it 'proxies to the backend' do
      expect(database.backend).to receive(:read_content_from)
      table.read_content
    end
  end

  describe '#write_content' do
    it 'proxies to the backend' do
      expect(database.backend).to(
        receive(:write_content_to) do |_, cont, loc|
          expect(cont).to eq(:content)
          expect(loc).to eq(:locale)
        end
      )

      table.write_content(:content, :locale)
    end
  end
end
