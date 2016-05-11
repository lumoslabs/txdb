module Txdb
  autoload :Backends,         'txdb/backends'
  autoload :Config,           'txdb/config'
  autoload :Database,         'txdb/database'
  autoload :Table,            'txdb/table'
  autoload :TransifexProject, 'txdb/transifex_project'
  autoload :TxResource,       'txdb/tx_resource'

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
  end

  Txdb::Backends.register('globalize', Txdb::Backends::Globalize::Backend)
end
