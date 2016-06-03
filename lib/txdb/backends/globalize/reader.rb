require 'txgh'

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
          [Txdb::TxResource.new(resource, serialized_content)]
        end

        private

        def resource
          @resource ||= Txgh::TxResource.new(
            project_slug, resource_slug, Globalize::Backend::RESOURCE_TYPE,
            source_lang, source_file, nil, nil
          )
        end

        def project_slug
          table.database.transifex_project.project_slug
        end

        def resource_slug
          resource_slug_for(table)
        end

        def source_lang
          table.source_lang
        end

        def source_file
          table.name
        end

        def serialized_content
          YAML.dump(content)
        end

        def content
          @content ||= { origin_table_name(table.name) => content_for_records }
        end

        def content_for_records
          each_record.each_with_object({}) do |record, ret|
            record_content = content_for_record(record)
            next if record_content.empty?
            ret[record[:id]] = record_content
          end
        end

        def content_for_record(record)
          table.columns.each_with_object({}) do |col, ret|
            begin
              value = col.deserialize(record[col.name.to_sym])

              unless value.to_s.strip.empty?
                ret[col.name] = value
              end
            rescue ColumnDeserializationError
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
