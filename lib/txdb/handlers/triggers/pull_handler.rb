module Txdb
  module Handlers
    module Triggers

      class PullHandler < Handler
        def handle
          handle_safely do
            database.locales.each do |locale|
              downloader.download_table(table, locale)
            end

            respond_with(200, {})
          end
        end

        private

        def downloader
          @downloader ||= Downloader.new(database)
        end
      end

    end
  end
end
