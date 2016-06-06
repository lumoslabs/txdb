require 'spec_helper'
require 'spec_helpers/test_configurator'
require 'yaml'

include Txdb

describe Table, test_config: true do
  let(:database) do
    TestConfigurator.setup do
      create_table(:my_table) do
        primary_key :id
      end
    end
  end

  let(:table) { database.find_table(:my_table) }

  describe '#connection' do
    it 'returns a dataset primed to select from the table' do
      expect(table.connection).to be_a(Sequel::Dataset)
      expect(table.connection.sql).to eq('SELECT * FROM `my_table`')
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
