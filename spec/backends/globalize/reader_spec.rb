require 'spec_helper'
require 'spec_helpers/globalize_db'

include Txdb::Backends

describe Globalize::Reader, globalize_db: true do
  include_context :globalize

  describe '#read_content' do
    it 'reads data from the given table and puts it into a hash' do
      sprocket_id = widgets.insert(name: 'sprocket')
      flange_id = widgets.insert(name: 'flange')
      widget_translations.insert(widget_id: sprocket_id, locale: 'es', name: 'sproqueta')
      widget_translations.insert(widget_id: flange_id, locale: 'es', name: 'flango')

      reader = Globalize::Reader.new(widget_translations_table)
      expect(reader.read_content).to eq({
        'widgets' => {
          1 => { 'name' => 'sprocket' },
          2 => { 'name' => 'flange' }
        }
      })
    end
  end
end
