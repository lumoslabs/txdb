require 'spec_helper'
require 'spec_helpers/test_db'
require 'spec_helpers/test_backend'

include Txdb

describe Downloader, test_db: true do
  let(:database) { Txdb::Config.databases.first }
  let(:downloader) { Downloader.new(database) }
  let(:transifex_api) { double(:transifex_api) }

  before(:each) do
    allow(database.transifex_project).to(
      receive(:api).and_return(transifex_api)
    )
  end

  describe '#download' do
    it 'downloads translations from Transifex and writes them to the db' do
      expect(transifex_api).to receive(:download) do |resource, locale|
        expect(resource.project_slug).to eq('myproject')
        expect(resource.resource_slug).to eq('spec_test.sqlite3-my_table')
        expect(locale).to eq('es')
        YAML.dump('widgets')
      end

      expect { downloader.download('es') }.to(
        change { TestBackend.writes.size }.from(0).to(1)
      )

      expect(TestBackend.writes.first).to eq(
        table: database.tables.first.name, locale: 'es', content: 'widgets'
      )
    end
  end
end
