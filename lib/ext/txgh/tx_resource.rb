require 'txgh'

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
