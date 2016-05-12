require 'spec_helper'

include Txdb::Backends

describe Globalize::Helpers do
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
end
