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
    let(:database) { TestDb.database }
    let(:table) { database.tables.first }

    it 'constructs a slug from the database and table names' do
      expect(Globalize::Helpers.resource_slug_for(table)).to eq(
        'spec_test.sqlite3-my_table'
      )
    end
  end
end
