module Txdb
  class ConnectionString
    TEMPLATES = {
      mysql2: "%{adapter}://%{username}:%{password}@%{host}:%{port}/%{database}",
      sqlite: "%{adapter}://%{database}"
    }

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def string
      TEMPLATES[options[:adapter].to_sym] % options
    end
  end
end
