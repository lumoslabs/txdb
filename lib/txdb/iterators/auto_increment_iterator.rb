module Txdb
  module Iterators
    class AutoIncrementIterator
      include Enumerable

      DEFAULT_BATCH_SIZE = 50
      DEFAULT_COLUMN = :id

      attr_reader :table, :batch_size, :column

      def initialize(table, options = {})
        @table = table
        @batch_size = options.fetch(:batch_size, DEFAULT_BATCH_SIZE)
        @column = options.fetch(:column, DEFAULT_COLUMN)
      end

      def each
        return to_enum(__method__) unless block_given?

        counter = 0
        last_value = nil
        sql_column = Sequel.expr(column)

        loop do
          records = table.db
            .from(table_name)
            .where { sql_column >= counter }
            .order(column)
            .limit(batch_size)

          break if records.count == 0

          records.each do |record|
            yield record
            last_value = record[column]
          end

          counter = last_value + 1
        end
      end

      alias_method :each_record, :each

      private

      def table_name
        table.name
      end
    end
  end
end
