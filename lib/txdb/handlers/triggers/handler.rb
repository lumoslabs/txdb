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

        def databases
          @databases ||= if database_name = request.params['database']
            Txdb::Config.databases.select do |database|
              database.database == database_name
            end
          else
            Txdb::Config.databases
          end
        end

        def tables
          @tables ||= each_table_in(databases).select do |table|
            table.name == request.params['table']
          end
        end

        def each_table_in(databases, &block)
          return to_enum(__method__, databases) unless block_given?
          databases.each { |database| database.tables.each(&block) }
        end
      end
    end
  end
end
