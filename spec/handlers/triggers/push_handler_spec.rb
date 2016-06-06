require 'spec_helper'
require 'spec_helpers/test_backend'
require 'spec_helpers/test_configurator'
require 'uri'
require 'yaml'

include Txdb::Handlers::Triggers

describe PushHandler, test_db: true do
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

  it 'uploads the table' do
    expect(database.transifex_api).to receive(:create_or_update)

    expect { patch('/push', params) }.to(
      change { Txdb::TestBackend.reads.size }.from(0).to(1)
    )

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('{}')

    expect(Txdb::TestBackend.reads).to include(table: table.name)
  end

  it 'reports errors' do
    expect(database.transifex_api).to receive(:create_or_update).and_raise('jelly beans')
    patch '/push', params
    expect(last_response.status).to eq(500)
    expect(JSON.parse(last_response.body)).to eq(
      [{ 'error' => 'Internal server error: jelly beans' }]
    )
  end
end
