module Txdb
  module Backends
    module Globalize

      class Reader
        include Helpers

        attr_reader :table

        def initialize(table)
          @table = table
        end

        def read_content
          { origin_table_name(table.name) => content_for_records }
        end

        private

        def content_for_records
          each_record.each_with_object({}) do |record, ret|
            ret[record[:id]] = content_for_record(record)
          end
        end

        def content_for_record(record)
          table.columns.each_with_object({}) do |col, ret|
            value = record[col.to_sym]

            unless value.to_s.strip.empty?
              ret[col] = value
            end
          end
        end

        def each_record
          return to_enum(__method__) unless block_given?

          counter = 0
          last_id = nil

          loop do
            records = table.db
              .from(origin_table_name(table.name))
              .where { id >= counter }
              .order(:id)
              .limit(50)

            break if records.count == 0

            records.each do |record|
              yield record
              last_id = record[:id]
            end

            counter = last_id + 1
          end
        end
      end

    end
  end
end
