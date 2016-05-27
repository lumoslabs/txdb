require 'pry-byebug'
require 'rack/test'
require 'rake'
require 'rspec'
require 'sequel'
require 'sqlite3'
require 'txdb'

require 'spec_helpers/env_helpers'
require 'spec_helpers/test_backend'

Sequel.default_timezone = :utc

RSpec.configure do |config|
  config.before(:each) do
    Txdb::TestBackend.reset
  end

  config.include(EnvHelpers)
end

Txdb::Backends.register('test-backend', Txdb::TestBackend)
