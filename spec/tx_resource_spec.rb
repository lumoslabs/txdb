require 'spec_helper'
require 'spec_helpers/test_db'

include Txdb

describe TxResource, test_db: true do
  let(:database) { TestDb.database }
  let(:table) { database.tables.first }
  let(:resource) { table.resource }

  it 'proxies methods to the underlying Txgh::TxResource' do
    expect(resource.project_slug).to eq('myproject')
    expect(resource.resource_slug).to(
      eq(Txgh::Utils.slugify("#{database.database}-#{table.name}"))
    )
  end
end
