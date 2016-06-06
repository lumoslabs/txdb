require 'spec_helper'
require 'spec_helpers/test_configurator'

include Txdb::Iterators

describe GlobalizeIterator, test_config: true do
  let(:database) do
    Txdb::TestConfigurator.setup do
      create_table(:teams) do
        primary_key :id
        string :name
      end

      create_table(:team_translations) do
        primary_key :id
        string :name, translate: true
        string :locale
        source_lang 'en'
      end
    end
  end

  let(:teams_table) { database.find_table(:teams) }
  let(:team_translations_table) { database.find_table(:team_translations) }
  let(:teams) { %w(seahawks warriors giants mariners sounders) }

  let(:iterator) do
    GlobalizeIterator.new(team_translations_table)
  end

  it 'iterates over the items in the parent table' do
    teams.each do |team|
      teams_table.connection << { name: team }
      team_translations_table.connection << { name: "#{team}-es", locale: 'es' }
    end

    entries = iterator.map { |entry| entry[:name] }

    # should be equivalent to the English team names, since it should have
    # iterated over entries in the parent table, not the translations table
    expect(entries.sort).to eq(teams.sort)
  end
end
