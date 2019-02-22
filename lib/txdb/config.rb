require 'yaml'
require 'erb'

module Txdb
  class Config
    class << self
      def databases
        @databases ||= raw_config[:databases].map do |database_config|
          Database.new(database_config)
        end
      end

      def each_table(&block)
        return to_enum(__method__) unless block_given?
        databases.each { |database| database.tables.each(&block) }
      end

      private

      def raw_config
        @raw_config ||= begin
          scheme, payload = ENV['TXDB_CONFIG'].split('://')
          send(:"load_#{scheme}", payload)
        end
      end

      def load_file(payload)
        deep_symbolize_keys(parse(File.read(payload)))
      end

      def load_raw(payload)
        deep_symbolize_keys(parse(payload))
      end

      def parse(str)
        YAML.load(ERB.new(str).result(binding))
      end

      def deep_symbolize_keys(obj)
        case obj
          when Hash
            obj.each_with_object({}) do |(k, v), ret|
              ret[k.to_sym] = deep_symbolize_keys(v)
            end

          when Array
            obj.map do |elem|
              deep_symbolize_keys(elem)
            end

          else
            obj
        end
      end
    end
  end
end
