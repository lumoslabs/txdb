require 'txgh'

module Txdb
  class TxResource
    RESOURCE_TYPE = 'YAML'

    class << self
      def from_table(table)
        # project_slug, resource_slug, type, source_lang, source_file,
        # lang_map, translation_file
        new(
          Txgh::TxResource.new(
            project_slug(table), resource_slug(table), RESOURCE_TYPE,
            source_lang(table), nil, nil, nil
          )
        )
      end

      private

      def project_slug(table)
        table.database.transifex_project.project_slug
      end

      def resource_slug(table)
        Txgh::Utils.slugify(table.name)
      end

      def source_lang(table)
        table.source_lang
      end
    end

    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def respond_to?(method)
      resource.respond_to?(method)
    end

    def method_missing(method, *args, &block)
      resource.send(method, *args, &block)
    end
  end
end
