require 'spec_helper'
require 'spec_helpers/test_db'

include Txdb::Iterators

describe AutoIncrementIterator, test_db: true do
  let(:database) do
    TestDb.setup do
      create_table(:teams) do
        primary_key :id
        string :name, translate: true
        source_lang 'en'
      end
    end
  end

  let(:table) { database.tables.first }
  let(:teams) { %w(seahawks warriors giants mariners sounders) }

  let(:iterator) do
    AutoIncrementIterator.new(table)
  end

  it 'iterates sequentially over every database entry' do
    entries = teams.map { |team| { name: team } }
    entries.each { |entry| table.db << entry }

    iterator.each do |db_entry|
      entries.delete_if { |entry| db_entry[:name] == entry[:name] }
    end

    expect(entries).to be_empty
  end
end
