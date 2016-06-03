module Txdb
  module ColumnTypes
    autoload :String, 'txdb/column_types/string'
    autoload :Yaml,   'txdb/column_types/yaml'

    class ColumnDeserializationError < StandardError
      attr_reader :message, :original_error

      def initialize(message, original_error)
        @message = message
        @original_error = original_error
      end
    end

    class << self
      def register(name, klass)
        all[name] = klass
      end

      def get(name)
        all[name]
      end

      def all
        @all ||= {}
      end
    end
  end
end
