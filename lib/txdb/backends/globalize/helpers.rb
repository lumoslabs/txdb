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
      end

      Helpers.extend(Helpers)

    end
  end
end
