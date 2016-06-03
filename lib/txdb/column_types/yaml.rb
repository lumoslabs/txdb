require 'yaml'

module Txdb
  module ColumnTypes
    class Yaml

      class << self
        def serialize(content)
          YAML.dump(content)
        end

        def deserialize(str)
          YAML.load(str)
        rescue Psych::SyntaxError => e
          raise ColumnDeserializationError, 'Error deserializing YAML column', e
        end
      end

    end
  end
end
