module Txdb
  module Handlers
    module Triggers

      class PullHandler < Handler
        def handle
          handle_safely do
            locales.each do |locale|
              downloader.download_table(table, locale)
            end

            respond_with(200, {})
          end
        end

        private

        def downloader
          @downloader ||= Downloader.new(database)
        end

        def locales
          database.transifex_api
            .get_languages(database.transifex_project.project_slug)
            .map { |locale| locale['language_code'] }
        end
      end

    end
  end
end
