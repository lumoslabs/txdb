require 'sequel'

module Txdb
  class Database
    DEFAULT_HOST = '127.0.0.1'
    DEFAULT_PORT = '3306'
    DEFAULT_POOL = 10

    attr_reader :adapter, :backend, :username, :password, :host, :port, :database
    attr_reader :pool, :transifex_project, :tables, :connection_string

    def initialize(options = {})
      @adapter = options.fetch(:adapter)
      @backend = Txdb::Backends.get(options.fetch(:backend))
      @username = options.fetch(:username)
      @password = options.fetch(:password)
      @host = options.fetch(:host, DEFAULT_HOST)
      @port = options.fetch(:port, DEFAULT_PORT)
      @database = options.fetch(:database)
      @pool = options.fetch(:pool, DEFAULT_POOL)
      @transifex_project = TransifexProject.new(options.fetch(:transifex))
      @connection_string = ConnectionString.new(options).string
      @tables = options.fetch(:tables).map do |table_config|
        Table.new(self, table_config)
      end
    end

    def connection
      @connection ||= Sequel.connect(connection_string, max_connections: pool)
    end

    def from(*args, &block)
      connection.from(*args, &block)
    end

    def transifex_api
      transifex_project.api
    end

    def find_table(name)
      name = name.to_s
      tables.find { |table| table.name == name }
    end
  end
end
