module Txdb
  module Backends
    autoload :Globalize, 'txdb/backends/globalize'

    class << self
      def register(name, klass)
        backends[name] = klass
      end

      def get(name)
        backends[name]
      end

      private

      def backends
        @backends ||= {}
      end
    end
  end
end
