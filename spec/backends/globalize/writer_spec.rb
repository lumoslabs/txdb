require 'spec_helper'
require 'helpers/globalize_db'

include Txdb::Backends

describe Globalize::Writer, globalize: true do
  include_context :globalize

  describe '#write_content' do
    it 'inserts the translations into the database' do
      sprocket_id = widgets.insert(name: 'sprocket')
      writer = Globalize::Writer.new(widget_translations_table)

      content = {
        'widgets' => {
          sprocket_id => { name: 'sproqueta' }
        }
      }

      expect { writer.write_content(content, 'es') }.to(
        change { widget_translations.count }.from(0).to(1)
      )

      translation = widget_translations.first

      expect(translation).to include(
        widget_id: sprocket_id, name: 'sproqueta', locale: 'es'
      )
    end

    it 'updates the record if it already exists' do
      sprocket_id = widgets.insert(name: 'sprocket')
      sprocket_trans_id = widget_translations.insert(
        widget_id: sprocket_id, locale: 'es', name: 'sproqueta'
      )

      writer = Globalize::Writer.new(widget_translations_table)

      content = {
        'widgets' => {
          sprocket_id => { name: 'sproqueta2' }
        }
      }

      expect { writer.write_content(content, 'es') }.to_not(
        change { widget_translations.count }
      )

      translation = widget_translations.where(id: sprocket_trans_id).first
      expect(translation).to include(name: 'sproqueta2')
    end
  end
end
