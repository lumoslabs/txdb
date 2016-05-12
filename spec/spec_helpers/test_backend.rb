module Txdb
  class TestBackend
    class << self
      def reads
        @reads ||= []
      end

      def writes
        @writes ||= []
      end

      def reset
        @reads = nil
        @writes = nil
      end

      def read_content_from(table)
        reads << { table: table.name }
        {}
      end

      def write_content_to(table, content, locale)
        writes << { table: table.name, content: content, locale: locale }
        nil
      end
    end
  end
end
