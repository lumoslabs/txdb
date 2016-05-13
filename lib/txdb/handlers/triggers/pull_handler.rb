module Txdb
  module Handlers
    module Triggers

      class PullHandler < Handler
        def handle
          tables.each do |table|
            locales_for(table).each do |locale|
              Downloader.new(table.database).download_table(table, locale)
            end
          end

          respond_with(200, {})
        end

        private

        def locales_for(table)
          locale_cache[table.resource.project_slug] ||=
            table.database.transifex_api
              .get_languages(table.resource.project_slug)
              .map { |locale| locale['language_code'] }
        end

        def locale_cache
          @locale_cache ||= {}
        end
      end

    end
  end
end
