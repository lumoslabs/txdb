module Txdb
  module ColumnTypes
    class String

      class << self
        def serialize(content)
          content.to_s
        end

        def deserialize(str)
          str
        end
      end

    end
  end
end
