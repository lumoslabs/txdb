module Txdb
  module Backends
    module Globalize
      autoload :Backend, 'txdb/backends/globalize/backend'
      autoload :Helpers, 'txdb/backends/globalize/helpers'
      autoload :Reader,  'txdb/backends/globalize/reader'
      autoload :Writer,  'txdb/backends/globalize/writer'
    end
  end
end
