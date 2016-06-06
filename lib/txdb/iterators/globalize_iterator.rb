module Txdb
  module Iterators
    class GlobalizeIterator < AutoIncrementIterator
      private

      include Backends::Globalize::Helpers

      def table_name
        origin_table_name(table.name)
      end
    end
  end
end
