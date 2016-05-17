module Txdb
  module Handlers
    module Triggers
      autoload :Handler,     'txdb/handlers/triggers/handler'
      autoload :PullHandler, 'txdb/handlers/triggers/pull_handler'
      autoload :PushHandler, 'txdb/handlers/triggers/push_handler'
    end
  end
end
