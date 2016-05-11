module Txdb
  module Backends
    module Globalize

      class Backend
        class << self
          def read_content_from(table)
            Reader.new(table).read_content
          end

          def write_content_to(table, content, locale)
            Writer.new(table).write_content(content, locale)
          end
        end
      end

    end
  end
end
