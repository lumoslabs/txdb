require 'ext/txgh/tx_resource'

module Txdb
  autoload :Application,      'txdb/app'
  autoload :Backends,         'txdb/backends'
  autoload :Config,           'txdb/config'
  autoload :ConnectionString, 'txdb/connection_string'
  autoload :Database,         'txdb/database'
  autoload :Downloader,       'txdb/downloader'
  autoload :Handlers,         'txdb/handlers'
  autoload :Hooks,            'txdb/app'
  autoload :Iterators,        'txdb/iterators'
  autoload :Response,         'txdb/response'
  autoload :ResponseHelpers,  'txdb/response_helpers'
  autoload :Table,            'txdb/table'
  autoload :TransifexProject, 'txdb/transifex_project'
  autoload :Triggers,         'txdb/app'
  autoload :TxResource,       'txdb/tx_resource'
  autoload :Uploader,         'txdb/uploader'

  DEFAULT_ENV = 'development'

  class << self
    def upload
      Txdb::Config.databases.each do |database|
        Uploader.upload(database)
      end
    end

    def download
      Txdb::Config.databases.each do |database|
        Downloader.download(database)
      end
    end

    def env
      ENV.fetch('TXDB_ENV', DEFAULT_ENV)
    end
  end

  Txdb::Backends.register('globalize', Txdb::Backends::Globalize::Backend)
end
