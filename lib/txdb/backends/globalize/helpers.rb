require 'active_support'

module Txdb
  module Backends
    module Globalize

      module Helpers
        def origin_table_name(table_name)
          ActiveSupport::Inflector.pluralize(
            table_name.sub(/_translations\z/, '')
          )
        end

        def resource_slug_for(table)
          Txgh::Utils.slugify("#{table.database.database}-#{table.name}")
        end
      end

      Helpers.extend(Helpers)

    end
  end
end
