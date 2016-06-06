require 'spec_helper'
require 'spec_helpers/test_backend'
require 'spec_helpers/test_configurator'
require 'uri'
require 'yaml'

include Txdb::Handlers::Triggers

describe PullHandler, test_config: true do
  include Rack::Test::Methods

  let(:database) do
    Txdb::TestConfigurator.setup do
      create_table(:foo) do
        primary_key :id
      end
    end
  end

  let(:table) { database.find_table(:foo) }
  let(:project) { database.transifex_project }

  def app
    Txdb::Triggers
  end

  before(:each) do
    allow(Txdb::Config).to receive(:databases).and_return([database])
  end

  let(:params) do
    { 'database' => database.database, 'table' => table.name }
  end

  it 'downloads the table for each locale' do
    locales = [{ 'language_code' => 'es' }, { 'language_code' => 'ja' }]
    content = { 'phrase' => 'trans' }

    expect(database.transifex_api).to receive(:get_languages).and_return(locales)
    allow(database.transifex_api).to receive(:download).and_return(YAML.dump(content))
    expect(database.transifex_api).to receive(:get_resources).and_return(
      [Txdb::TestBackend.resource.to_api_h]
    )

    expect { patch('/pull', params) }.to(
      change { Txdb::TestBackend.writes.size }.from(0).to(2)
    )

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('{}')

    expect(Txdb::TestBackend.writes.first[:locale]).to eq('es')
    expect(Txdb::TestBackend.writes.last[:locale]).to eq('ja')

    Txdb::TestBackend.writes.each do |write|
      expect(write[:table]).to eq(table.name)

      expect(write[:resource].project_slug).to(
        eq(Txdb::TestBackend.resource.project_slug)
      )

      expect(write[:resource].resource_slug).to(
        eq(Txdb::TestBackend.resource.resource_slug)
      )
    end
  end

  it 'reports errors' do
    expect(database.transifex_api).to receive(:get_languages).and_raise('jelly beans')
    patch '/pull', params
    expect(last_response.status).to eq(500)
    expect(JSON.parse(last_response.body)).to eq(
      [{ 'error' => 'Internal server error: jelly beans' }]
    )
  end
end
