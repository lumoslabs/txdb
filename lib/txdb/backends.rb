module Txdb
  module Backends
    autoload :Globalize, 'txdb/backends/globalize'

    class << self
      def register(name, klass)
        all[name] = klass
      end

      def get(name)
        all[name]
      end

      def all
        @all ||= {}
      end
    end
  end
end
