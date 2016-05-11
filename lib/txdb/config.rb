require 'YAML'

module Txdb
  class Config
    class << self
      def databases
        @databases ||= raw_config['databases'].map do |database_config|
          Database.new(database_config)
        end
      end

      private

      def raw_config
        @raw_config ||= begin
          scheme, payload = ENV['TXGH_DB_CONFIG'].split('://')
          send(:"load_#{scheme}", payload)
        end
      end

      def load_file(payload)
        YAML.load_file(payload)
      end

      def load_raw(payload)
        YAML.load(payload)
      end
    end
  end
end
