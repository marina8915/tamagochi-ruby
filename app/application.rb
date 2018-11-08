require './app/controllers/errors_controller'
require './app/controllers/pages_controller'
require './app/controllers/pat_controller'
require './app/models/pat'

module Tamagochi
  class Application
    def self.call(env)
      req = Rack::Request.new(env)
      return PagesController.create if req.get?  && req.path == '/'
      return PatController.pat(req)  if req.post? && req.path == '/pat'
      ErrorsController.not_found
    end
  end
end