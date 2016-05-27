require 'spec_helper'
require 'spec_helpers/globalize_db'
require 'yaml'

include Txdb::Backends

describe Globalize::Writer, globalize_db: true do
  include_context :globalize

  describe '#write_content' do
    let(:base_resource) do
      # project_slug, resource_slug, type, source_lang, source_file,
      # lang_map, translation_file
      Txgh::TxResource.new(
        'project_slug', 'resource_slug', Globalize::Backend::RESOURCE_TYPE,
        'source_lang', 'source_file', nil, nil
      )
    end

    it 'inserts the translations into the database' do
      sprocket_id = widgets.insert(name: 'sprocket')
      writer = Globalize::Writer.new(widget_translations_table)

      content = YAML.dump(
        'widgets' => {
          sprocket_id => { name: 'sproqueta' }
        }
      )

      resource = Txdb::TxResource.new(base_resource, content)

      expect { writer.write_content(resource, 'es') }.to(
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

      content = YAML.dump(
        'widgets' => {
          sprocket_id => { name: 'sproqueta2' }
        }
      )

      resource = Txdb::TxResource.new(base_resource, content)

      expect { writer.write_content(resource, 'es') }.to_not(
        change { widget_translations.count }
      )

      translation = widget_translations.where(id: sprocket_trans_id).first
      expect(translation).to include(name: 'sproqueta2')
    end
  end
end
