module Txgh
  class TxResource
    class << self
      def from_api_response(project_slug, response)
        new(
          project_slug,
          response['slug'],
          response['i18n_type'],
          response['source_language_code'],
          response['name'],
          '', nil
        )
      end
    end
  end
end

module Txdb
  class TxResource
    attr_reader :original, :content

    def initialize(original, content)
      @original = original
      @content = content
    end

    def respond_to?(method)
      original.respond_to?(method)
    end

    def method_missing(method, *args, &block)
      original.send(method, *args, &block)
    end
  end
end
