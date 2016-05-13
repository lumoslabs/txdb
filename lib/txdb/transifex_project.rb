require 'txgh'

module Txdb
  class TransifexProject
    attr_reader :organization, :project_slug, :username, :password
    attr_reader :webhook_secret, :api

    def initialize(options = {})
      @organization = options.fetch(:organization)
      @project_slug = options.fetch(:project_slug)
      @username = options.fetch(:username)
      @password = options.fetch(:password)
      @webhook_secret = options.fetch(:webhook_secret)
      @api = Txgh::TransifexApi.create_from_credentials(username, password)
    end
  end
end
