require 'sinatra'
require 'sinatra/json'

module Txdb
  module RespondWith
    def respond_with(resp)
      env['txdb.response'] = resp
      status resp.status
      json resp.body
    end
  end

  class Application < Sinatra::Base
    helpers RespondWith

    get '/health_check' do
      respond_with(
        Response.new(200, {})
      )
    end
  end

  class Hooks < Sinatra::Base
    include Txdb::Handlers

    helpers RespondWith

    post '/transifex' do
      respond_with(HookHandler.handle_request(request))
    end
  end

  class Triggers < Sinatra::Base
    include Txdb::Handlers::Triggers

    helpers RespondWith

    patch '/push' do
      respond_with(PushHandler.handle_request(request))
    end

    patch '/pull' do
      respond_with(PullHandler.handle_request(request))
    end
  end
end
