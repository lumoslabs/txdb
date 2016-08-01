module Txdb
  module Iterators
    class GlobalizeIterator < AutoIncrementIterator
      private

      include Backends::Globalize::Helpers

      def records_since(counter)
        super
          .join(origin_table, column => origin_column)
          .where(locale_column => table.database.source_locale)
      end

      def locale_column
        Sequel.qualify(table_name, :locale)
      end

      def origin_column
        Sequel.qualify(table_name, origin_column_name(table_name))
      end

      def origin_table
        Sequel.expr(origin_table_name(table_name))
      end
    end
  end
end
