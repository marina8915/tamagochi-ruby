# frozen_string_literal: true

require 'erb'
require 'time'
require './app/models/pet'
require './app/models/error'

module Tamagotchi
  # class PetController for model Pat
  class PetController
    class << self
      def pet(req)
        if req.params.key?('name')
          @pet = create_pet(req)
          # check if @pet_name less then 5 characters then create error
          if @pet_name.delete(' ').size >= 5
            return_page(status: 201, view: 'pet')
          else
            return_error('The name must contain at least 5 characters.')
            return_page(status: 422, view: 'page')
          end
        end
      end

      # method action for create, play, eat, drink, sleep, awake
      def action(req)
        @pet = return_pet(req)
        if @pet.check_health
          return_error('Your pet die.')
          return_page(status: 201, view: 'page')
        else
          return_page(status: 201, view: 'pet')
        end
      end

      def return_error(text)
        @error = Error.new(display: true, text: text)
      end

      def return_page(status:, view:)
        path = "./app/views/#{view}.html.erb"
        template = ERB.new(File.read(path)).result(binding)
        [status, { 'Content-Type' => 'text/html' }, [template]]
      end

      def create_pet(req)
        @pet_name = req['name'] || ''
        params_hash = { appetite: 80, health: 100, humor: 100, thirst: 90 }
        ignore_hash = { eat: 0, drink: 0, play: 0, sleep: 0 }
        Pet.new(req: req, name: @pet_name, params: params_hash,
                ignore: ignore_hash, time: Time.now, dreams: false)
      end

      def return_pet(req)
        Pet.new(req: req, name: @pet_name, params: @pet.parameters,
                ignore: @pet.ignore, time: @pet.time, dreams: @pet.dreams)
      end
    end
  end
end
