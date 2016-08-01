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
        [resource]
      end

      def write_content_to(table, resource, locale)
        writes << { table: table.name, resource: resource, locale: locale }
        nil
      end

      def owns_resource?(table, resource)
        true
      end

      def base_resource
        @base_resource ||= Txgh::TxResource.new(
          'myproject', 'resource_slug', 'type',
          'source_locale', 'source_file', nil, nil
        )
      end

      def content
        @content ||= 'fake content'
      end

      def resource
        @resource ||= Txdb::TxResource.new(base_resource, content)
      end
    end
  end
end
