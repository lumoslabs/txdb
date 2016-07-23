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

        def write_content(resource, locale)
          content = deserialize_content(resource.content)
          content = content.fetch(table.name, {})

          content.each_pair do |foreign_id, fields|
            update_row(foreign_id, fields, locale)
          end
        end

        private

        def update_row(foreign_id, fields, locale)
          row = table.connection.where(
            origin_column => foreign_id, locale: locale
          )

          if row.empty?
            table.connection << fields
              .merge(origin_column => foreign_id, locale: locale)
              .merge(created_at)
              .merge(updated_at)
          else
            row.update(fields.merge(updated_at))
          end
        end

        def created_at
          return {} unless table.connection.columns.include?(:created_at)
          { created_at: get_utc_time }
        end

        def updated_at
          return {} unless table.connection.columns.include?(:updated_at)
          { updated_at: get_utc_time }
        end

        def get_utc_time
          Time.now.utc
        end

        def deserialize_content(content)
          YAML.load(content)
        end

        def origin_column
          origin_column_name(table.name)
        end
      end

    end
  end
end
