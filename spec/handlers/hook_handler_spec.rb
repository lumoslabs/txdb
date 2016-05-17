require 'spec_helper'
require 'spec_helpers/test_backend'
require 'spec_helpers/test_db'
require 'uri'
require 'yaml'

include Txdb::Handlers

describe HookHandler do
  include Rack::Test::Methods

  let(:database) { TestDb.database }
  let(:table) { database.tables.first }
  let(:project) { database.transifex_project }

  def app
    Txdb::Hooks
  end

  before(:each) do
    allow(Txdb::Config).to receive(:databases).and_return([database])
  end

  def sign(body)
    Txgh::TransifexRequestAuth.header_value(
      body, project.webhook_secret
    )
  end

  it "doesn't write content when unauthorized" do
    params = { 'resource' => table.resource.resource_slug, 'language' => 'es' }
    body = URI.encode_www_form(params.to_a)
    post '/transifex', body

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('{}')

    expect(Txdb::TestBackend.writes).to be_empty
  end

  context 'with an authorized request' do
    let(:content) { { 'phrase' => 'trans' } }
    let(:params) { { 'resource' => table.resource.resource_slug, 'language' => 'es' } }
    let(:body) { URI.encode_www_form(params.to_a) }
    let(:headers) { { Txgh::TransifexRequestAuth::RACK_HEADER => sign(body) } }

    it 'downloads and writes new content to the database' do
      expect(project.api).to receive(:download).and_return(YAML.dump(content))

      expect { post('/transifex', body, headers) }.to(
        change { Txdb::TestBackend.writes.size }.from(0).to(1)
      )

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('{}')

      expect(Txdb::TestBackend.writes).to include(
        locale: 'es', table: table.name, content: content
      )
    end

    it 'reports errors' do
      expect(project.api).to receive(:download).and_raise('jelly beans')

      post '/transifex', body, headers

      expect(last_response.status).to eq(500)
      expect(JSON.parse(last_response.body)).to eq(
        [{ 'error' => 'Internal server error: jelly beans' }]
      )
    end
  end
end
