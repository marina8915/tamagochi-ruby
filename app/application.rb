require './app/controllers/errors_controller'
require './app/controllers/pages_controller'
require './app/models/pat'

module Tamagochi
  class Application
    def self.call(env)
      req = Rack::Request.new(env)
      return PagesController.root if req.get?  && req.path == '/'
      ErrorsController.not_found
    end
  end
end