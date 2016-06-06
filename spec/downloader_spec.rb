require 'spec_helper'
require 'spec_helpers/test_configurator'
require 'spec_helpers/test_backend'

include Txdb

describe Downloader, test_config: true do
  let(:database) do
    TestConfigurator.setup do
      create_table(:foo) do
        primary_key :id
      end
    end
  end

  let(:downloader) { Downloader.new(database) }
  let(:transifex_api) { double(:transifex_api) }

  before(:each) do
    allow(database.transifex_project).to(
      receive(:api).and_return(transifex_api)
    )
  end

  describe '#download' do
    it 'downloads translations from Transifex and writes them to the db' do
      expect(transifex_api).to(
        receive(:get_resources)
          .with(database.transifex_project.project_slug)
          .and_return([{
            'slug' => 'fake_resource_slug',
            'i18n_type' => 'fake_i18n_type',
            'source_language_code' => 'en',
            'name' => 'fake_name',
          }])
      )

      content = YAML.dump({ foo: 'bar' })

      expect(transifex_api).to receive(:download) do |resource, locale|
        expect(resource.project_slug).to eq('myproject')
        expect(resource.resource_slug).to eq('fake_resource_slug')
        expect(locale).to eq('es')
        content
      end

      expect { downloader.download('es') }.to(
        change { TestBackend.writes.size }.from(0).to(1)
      )

      write = TestBackend.writes.first
      expect(write[:table]).to eq(database.tables.first.name)
      expect(write[:locale]).to eq('es')

      expect(write[:resource]).to be_a(Txdb::TxResource)
      expect(write[:resource].project_slug).to eq('myproject')
      expect(write[:resource].resource_slug).to eq('fake_resource_slug')
      expect(write[:resource].content).to eq(content)
    end
  end
end
