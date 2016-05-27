require 'spec_helper'
require 'spec_helpers/test_backend'
require 'spec_helpers/test_db'
require 'uri'
require 'yaml'

include Txdb
include Txdb::Handlers

describe HookHandler do
  include Rack::Test::Methods

  let(:database) { TestDb.database }
  let(:table) { database.tables.first }
  let(:project) { database.transifex_project }
  let(:resource) { TestBackend.resource }

  let(:body) { URI.encode_www_form(params.to_a) }
  let(:params) do
    {
      'project' => resource.project_slug,
      'resource' => resource.resource_slug,
      'language' => 'es'
    }
  end

  def app
    Txdb::Hooks
  end

  before(:each) do
    allow(Txdb::Config).to receive(:databases).and_return([database])
  end

  it "doesn't write content when unauthorized" do
    post '/transifex', body

    expect(last_response.status).to eq(401)
    expect(JSON.parse(last_response.body)).to eq([{ 'error' => 'Unauthorized' }])

    expect(Txdb::TestBackend.writes).to be_empty
  end

  context 'with an authorized request' do
    let(:content) { { 'phrase' => 'trans' } }

    before(:each) do
      header(
        Txgh::TransifexRequestAuth::TRANSIFEX_HEADER,
        Txgh::TransifexRequestAuth.header_value(body, project.webhook_secret)
      )
    end

    it 'downloads and writes new content to the database' do
      expect(project.api).to receive(:get_resource).and_return(resource.to_api_h)
      expect(project.api).to receive(:download).and_return(YAML.dump(content))

      expect { post('/transifex', body) }.to(
        change { Txdb::TestBackend.writes.size }.from(0).to(1)
      )

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('{}')

      write = Txdb::TestBackend.writes.first

      expect(write[:locale]).to eq('es')
      expect(write[:table]).to eq(table.name)
      expect(write[:resource]).to be_a(Txdb::TxResource)
      expect(write[:resource].project_slug).to eq(resource.project_slug)
      expect(write[:resource].resource_slug).to eq(resource.resource_slug)
    end

    it 'reports errors' do
      expect(project.api).to receive(:get_resource).and_raise('jelly beans')

      post '/transifex', body

      expect(last_response.status).to eq(500)
      expect(JSON.parse(last_response.body)).to eq(
        [{ 'error' => 'Internal server error: jelly beans' }]
      )
    end
  end
end
