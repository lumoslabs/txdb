require 'active_support'

module Txdb
  module Backends
    module Globalize

      module Helpers
        def origin_table_name
          @origin_table_name ||= ActiveSupport::Inflector.pluralize(
            table.name.sub(/_translations\z/, '')
          )
        end
      end

    end
  end
end
