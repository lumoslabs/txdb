require 'spec_helper'
require 'spec_helpers/test_db'

include Txdb::Backends

describe Globalize::Helpers, test_db: true do
  describe '.origin_table_name' do
    it 'pluralizes and removes the translations suffix' do
      origin = Globalize::Helpers.origin_table_name('widget_translations')
      expect(origin).to eq('widgets')
    end

    it 'handles unusual pluralizations (via ActiveSupport::Inflector)' do
      origin = Globalize::Helpers.origin_table_name('ox_translations')
      expect(origin).to eq('oxen')
    end
  end

  describe '#resource_slug_for' do
    let(:database) do
      TestConfigurator.setup do
        create_table(:my_table) do
          primary_key :id
        end
      end
    end

    let(:table) { database.find_table(:my_table) }

    it 'constructs a slug from the database and table names' do
      expect(Globalize::Helpers.resource_slug_for(table)).to eq(
        'spec_test.sqlite3-my_table'
      )
    end
  end
end
