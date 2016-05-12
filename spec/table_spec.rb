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

  describe '#resource' do
    it 'creates a TxResource from the table' do
      resource = table.resource
      expect(resource).to be_a(Txdb::TxResource)
      expect(resource.project_slug).to eq('myproject')
      expect(resource.resource_slug).to eq(table.name)
      expect(resource.source_file).to eq(table.name)
      expect(resource.source_lang).to eq('en')
    end
  end

  describe '#read_content' do
    let(:content) { { foo: 'bar' } }

    it 'dumps the content in YAML format' do
      expect(database.backend).to(
        receive(:read_content_from).and_return(content)
      )

      expect(table.read_content).to eq(YAML.dump(content))
    end
  end

  describe '#write_content' do
    let(:content) { { foo: 'bar' } }
    let(:locale) { 'es' }

    it 'parses and writes the content to the database' do
      expect(database.backend).to(
        receive(:write_content_to) do |_, cont, loc|
          expect(cont).to eq(content)
          expect(loc).to eq(locale)
        end
      )

      table.write_content(YAML.dump(content), locale)
    end
  end
end
