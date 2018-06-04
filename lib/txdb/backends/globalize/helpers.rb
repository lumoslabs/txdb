require 'active_support'

module Txdb
  module Backends
    module Globalize

      module Helpers
        def origin_table_name(table_name)
          ActiveSupport::Inflector.pluralize(
            origin_table_name_singular(table_name)
          ).to_sym
        end

        def origin_column_name(table_name)
          "#{origin_table_name_singular(table_name)}_id".to_sym
        end

        def resource_slug_for(table)
          Txdb::Utils.slugify("#{table.database.name}-#{table.name}")
        end

        private

        def origin_table_name_singular(table_name)
          table_name.sub(/_translations\z/, '')
        end
      end

      Helpers.extend(Helpers)

    end
  end
end
