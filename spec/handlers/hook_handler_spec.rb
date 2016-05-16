require 'spec_helper'
require 'spec_helpers/test_backend'
require 'spec_helpers/test_db'
require 'spec_helpers/test_request'
require 'uri'

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

  it 'downloads and writes new content to the database' do
    content = { 'phrase' => 'trans' }
    expect(project.api).to receive(:download).and_return(YAML.dump(content))
    params = { 'resource' => table.resource.resource_slug, 'language' => 'es' }
    body = URI.encode_www_form(params.to_a)
    headers = { Txgh::TransifexRequestAuth::RACK_HEADER => sign(body) }

    post '/transifex', body, headers

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('{}')

    expect(Txdb::TestBackend.writes).to include(
      locale: 'es', table: table.name, content: content
    )
  end
end
