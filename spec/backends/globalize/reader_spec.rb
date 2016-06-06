require 'spec_helper'
require 'spec_helpers/globalize_db'
require 'yaml'

include Txdb::Backends

describe Globalize::Reader, globalize_db: true do
  include_context :globalize

  describe '#read_content' do
    it 'reads data from the given table and returns an array of resources' do
      sprocket_id = widgets.connection.insert(name: 'sprocket')
      flange_id = widgets.connection.insert(name: 'flange')
      widget_translations.connection.insert(widget_id: sprocket_id, locale: 'es', name: 'sproqueta')
      widget_translations.connection.insert(widget_id: flange_id, locale: 'es', name: 'flango')

      reader = Globalize::Reader.new(widget_translations)
      resources = reader.read_content
      expect(resources.size).to eq(1)
      resource = resources.first

      expect(resource.source_file).to eq(widget_translations.name)
      expect(resource.project_slug).to eq(database.transifex_project.project_slug)
      expect(resource.resource_slug).to(
        eq(Globalize::Helpers.resource_slug_for(widget_translations))
      )

      expect(resource.content).to eq(
        YAML.dump(
          'widgets' => {
            1 => { 'name' => 'sprocket' },
            2 => { 'name' => 'flange' }
          }
        )
      )
    end
  end
end
