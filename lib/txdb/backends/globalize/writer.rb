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
          content = content.fetch(origin_table_name(table.name), {})

          content.each_pair do |id, fields|
            update_row(id, fields, locale)
          end
        end

        private

        def update_row(id, fields, locale)
          row = table.db.where(foreign_key.to_sym => id, locale: locale)

          if row.empty?
            table.db << fields
              .merge(foreign_key.to_sym => id, locale: locale)
              .merge(created_at)
              .merge(updated_at)
          else
            row.update(fields.merge(updated_at))
          end
        end

        def created_at
          if table.db.columns.include?(:created_at)
            { created_at: get_utc_time }
          else
            {}
          end
        end

        def updated_at
          if table.db.columns.include?(:updated_at)
            { updated_at: get_utc_time }
          else
            {}
          end
        end

        def get_utc_time
          Time.now.utc
        end

        def deserialize_content(content)
          YAML.load(content)
        end

        def foreign_key
          @foreign_key ||= table.name.sub(/_translations/, '_id')
        end
      end

    end
  end
end
