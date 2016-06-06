require 'spec_helpers/test_configurator'

module Txdb
  # The globalize configurator uses the functionality in the test configurator
  # to create a couple of test tables for testing globalize-specific scenarios.
  class GlobalizeConfigurator < TestConfigurator
    class << self
      def setup(&block)
        super do
          create_table(:widgets) do
            primary_key :id
            string :name
          end

          create_table(:widget_translations) do
            primary_key :id
            integer :widget_id
            string :locale
            string :name, translate: true
            source_lang 'en'
          end

          block.call if block
        end
      end
    end
  end
end

RSpec.shared_context(:globalize) do
  let(:database) { Txdb::GlobalizeConfigurator.setup }
  let(:widgets) { database.find_table(:widgets) }
  let(:widget_translations) { database.find_table(:widget_translations) }
end

RSpec.configure do |config|
  config.around(:each) do |example|
    Txdb::GlobalizeConfigurator.reset_db if example.metadata[:globalize_config]
    example.run
  end
end
