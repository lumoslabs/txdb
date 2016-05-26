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
