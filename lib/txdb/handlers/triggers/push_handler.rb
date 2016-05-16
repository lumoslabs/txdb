module Txdb
  module Handlers
    module Triggers

      class PushHandler < Handler
        def handle
          tables.each do |table|
            Uploader.new(table.database).upload_table(table)
          end

          respond_with(200, {})
        rescue => e
          respond_with_error(500, "Internal server error: #{e.message}", e)
        end
      end

    end
  end
end
