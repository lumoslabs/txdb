module Txdb
  module Backends
    module Globalize

      class Backend
        RESOURCE_TYPE = 'YAML_GENERIC'

        class << self
          def read_content_from(table)
            Reader.new(table).read_content
          end

          def write_content_to(table, resource, locale)
            Writer.new(table).write_content(resource, locale)
          end

          def owns_resource?(table, resource)
            resource.resource_slug == Helpers.resource_slug_for(table)
          end
        end
      end

    end
  end
end
