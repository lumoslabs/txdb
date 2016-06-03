module Txdb
  class Column
    DEFAULT_TYPE = ColumnTypes.get('string')

    attr_reader :name, :type

    def initialize(table, options = {})
      @table = table

      case options
        when String
          @name = options
          @type = DEFAULT_TYPE
        when Hash
          @name = options.fetch(:name)
          @type = options.fetch(:type, DEFAULT_TYPE)
      end
    end

    def serialize(content)
      type.serialize(content)
    end

    def deserialize(str)
      type.deserialize(str)
    end
  end
end
