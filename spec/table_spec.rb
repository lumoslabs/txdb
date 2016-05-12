require 'spec_helper'
require 'spec_helpers/test_db'
require 'spec_helpers/test_backend'

include Txdb

describe Table, test_db: true do
  let(:database) { Txdb::Config.databases.first }
  let(:table) { database.tables.first }

  it 'foo' do
  end
end
