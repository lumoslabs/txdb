require 'yaml'

module Txdb
  module Backends
    module Globalize

      class Writer
        include Helpers

        attr_reader :table

        def initialize(table)
          @table = table
        end

        def write_content(content, locale)
          content[origin_table_name(table.name)].each_pair do |id, fields|
            row = table.db.where(foreign_key.to_sym => id, locale: locale)

            if row.empty?
              table.db << fields.merge(
                foreign_key.to_sym => id, locale: locale
              )
            else
              row.update(fields)
            end
          end
        end

        private

        def foreign_key
          @foreign_key ||= table.name.sub(/_translations/, '_id')
        end
      end

    end
  end
end
