require 'spec_helper'
require 'spec_helpers/test_configurator'
require 'spec_helpers/test_backend'

include Txdb

describe Uploader, test_config: true do
  let(:database) do
    TestConfigurator.setup do
      create_table(:foo) do
        primary_key :id
      end
    end
  end

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
        expect(resource.project_slug).to eq(TestBackend.resource.project_slug)
        expect(resource.resource_slug).to eq(TestBackend.resource.resource_slug)
      end

      expect { uploader.upload }.to(
        change { TestBackend.reads.size }.from(0).to(1)
      )
    end
  end
end
