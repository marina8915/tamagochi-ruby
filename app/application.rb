# frozen_string_literal: true

require './app/controllers/errors_controller'
require './app/controllers/pages_controller'
require './app/controllers/pet_controller'
require './app/models/pet'

module Tamagochi
  # class Application
  class Application
    def self.call(env)
      req = Rack::Request.new(env)
      return PagesController.create if req.get?  && req.path == '/'
      return PetController.pet(req) if req.post? && req.path == '/pet'
      return PetController.action(req) if req.post? && req.path == '/play'
      return PetController.action(req) if req.post? && req.path == '/eat'
      return PetController.action(req) if req.post? && req.path == '/drink'
      return PetController.action(req) if req.post? && req.path == '/treat'

      ErrorsController.not_found
    end
  end
end
