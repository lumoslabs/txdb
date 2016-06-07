module Txdb
  module Handlers
    module Triggers
      class Handler
        include ResponseHelpers

        class << self
          def handle_request(request)
            new(request).handle
          end
        end

        attr_reader :request

        def initialize(request)
          @request = request
        end

        private

        def handle_safely
          yield
        rescue => e
          respond_with_error(500, "Internal server error: #{e.message}", e)
        end

        def database
          @database ||= Txdb::Config.databases.find do |database|
            database.name == request.params['database']
          end
        end

        def table
          @table ||= database.tables.find do |table|
            table.name == request.params['table']
          end
        end
      end
    end
  end
end
