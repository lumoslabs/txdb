module Txdb
  module Utils
    def slugify(text)
      text.gsub('/', '_')
    end
  end

  Utils.extend(Utils)
end
