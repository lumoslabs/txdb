require 'spec_helper'
require 'spec_helpers/test_db'
require 'spec_helpers/test_backend'

include Txdb

describe Uploader, test_db: true do
  let(:database) { TestDb.database }
  let(:uploader) { Uploader.new(database) }
  let(:transifex_api) { double(:transifex_api) }

  before(:each) do
    allow(database.transifex_project).to(
      receive(:api).and_return(transifex_api)
    )
  end

  describe '#upload' do
    it 'reads phrases from the database and uploads them to Transifex' do
      expect(transifex_api).to receive(:create_or_update) do |resource, content|
        expect(resource.project_slug).to eq('project_slug')
        expect(resource.resource_slug).to eq('resource_slug')
      end

      expect { uploader.upload }.to(
        change { TestBackend.reads.size }.from(0).to(1)
      )
    end
  end
end
