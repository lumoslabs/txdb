module Txdb
  module Handlers
    module Triggers

      class PushHandler < Handler
        def handle
          handle_safely do
            Uploader.new(database).upload_table(table)
            respond_with(200, {})
          end
        end
      end

    end
  end
end
